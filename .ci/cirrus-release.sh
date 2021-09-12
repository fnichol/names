#!/usr/bin/env sh
# shellcheck disable=SC3043

main() {
  set -eu
  if [ -n "${DEBUG:-}" ]; then set -v; fi
  if [ -n "${TRACE:-}" ]; then set -xv; fi

  local subcmd
  subcmd="$1"
  shift

  "$subcmd" "$@"
}

changelog_section() {
  local changelog_file="$1"
  local tag="$2"
  local version="${tag#v}"

  need_cmd awk

  awk -v version_header_pat="^## \\\[$version\\\] - " '
    BEGIN {
      version_section = 0
      urls_section = 0
    }

    # Start printing when the version section is found including the section
    # header
    $0 ~ version_header_pat {
      version_section = 1
      print
      next
    }
    # Stop printing when the next version section is found or when the urls
    # section is found
    version_section == 1 && (/^## \[/ || /^<!-- next-url -->$/) {
      version_section = 0
    }
    # Print lines while in the version section
    version_section == 1 {
      print
    }
    # Start printing when the urls section is found, including the section
    # comment
    /^<!-- next-url -->$/ {
      urls_section = 1
      print
      next
    }
    # Print lines while in the urls section
    urls_section == 1 {
      print
    }
  ' "$changelog_file"

}

ci_download() {
  local artifact="$1"
  shift

  need_cmd basename
  need_cmd curl

  if [ -z "${CIRRUS_BUILD_ID:-}" ]; then
    die "missing required environment variable: CIRRUS_BUILD_ID"
  fi

  local dest
  dest="$(basename "$artifact")"

  echo "--- Downlading Cirrus artifact '$artifact' to '$dest'" >&2

  curl \
    --fail \
    -X GET \
    --output "$dest" \
    "https://api.cirrus-ci.com/v1/artifact/build/$CIRRUS_BUILD_ID/$artifact" \
    "${@:---}"
}

gh_create_release() {
  local repo="$1"
  local tag="$2"
  local name="$3"
  local body="$4"
  local draft="$5"
  local prerelease="$6"

  need_cmd jo
  need_cmd jq
  need_cmd sed

  local payload
  payload="$(
    jo \
      tag_name="$tag" \
      name="$name" \
      body="$body" \
      draft="$draft" \
      prerelease="$prerelease"
  )"

  local response
  if ! response="$(
    gh_rest POST "/repos/$repo/releases" --data "$payload"
  )"; then
    echo "!!! Failed to create a release for tag $tag" >&2
    return 1
  fi

  echo "$response" | jq -r .upload_url | sed -E 's,\{.+\}$,,'
}

gh_create_version_release() {
  local repo="$1"
  local tag="$2"

  gh_delete_release "$repo" "$tag"

  local prerelease
  if echo "${tag#v}" | grep -q -E '^\d+\.\d+.\d+$'; then
    prerelease=false
  else
    prerelease=true
  fi

  echo "--- Creating GitHub *draft* release '$tag' for '$repo'" >&2

  gh_create_release \
    "$repo" \
    "$tag" \
    "$tag" \
    "Release ${tag#v}" \
    true \
    "$prerelease"
}

gh_delete_release() {
  local repo="$1"
  local tag="$2"

  local release_ids rid
  release_ids="$(gh_release_id_for_tag "$repo" "$tag" 2>/dev/null)"

  if [ -n "$release_ids" ]; then
    for rid in $release_ids; do
      echo "--- Deleting GitHub pre-existing release '$tag' ($rid)" >&2
      if ! gh_rest DELETE "/repos/$repo/releases/$rid" >/dev/null; then
        echo "!!! Failed to delete a pre-existing release '$tag' ($rid)" >&2
        return 1
      fi
    done
  fi
}

gh_download() {
  local repo="$1"
  shift
  local tag="$1"
  shift
  local asset="$1"
  shift

  need_cmd curl
  need_cmd jq

  if ! gh_rest GET "/repos/$repo/releases/tags/$tag" >/tmp/response; then
    echo "!!! Failed to find a release for tag $tag" >&2
    return 1
  fi

  local dl_url
  dl_url="$(
    jq -r ".assets[] | select(.name == \"$asset\") | .browser_download_url" \
      </tmp/response
  )"

  echo "--- Downlading GitHub asset '$asset' from '$repo' ($tag)" >&2

  curl \
    --fail \
    -X GET \
    --location \
    --output "$asset" \
    "$dl_url" \
    "${@:---}"
}

gh_publish_release() {
  local repo="$1"
  local tag="$2"
  local changelog_file="$3"

  need_cmd jo
  need_cmd jq

  local release_id
  release_id="$(gh_release_id_for_tag "$repo" "$tag")"

  local body
  if [ "$tag" = "nightly" ]; then
    body=""
  else
    local changelog_section
    changelog_section="$(changelog_section "$changelog_file" "$tag")"

    body="$changelog_section"
  fi

  local payload
  payload="$(
    jo \
      draft=false \
      name="Release ${tag#v}" \
      body="$body"
  )"

  echo "--- Publishing GitHub release '$tag' for '$repo'" >&2

  local response
  if ! response="$(
    gh_rest POST "/repos/$repo/releases/$release_id" --data "$payload"
  )"; then
    echo "!!! Failed to update a release for tag $tag" >&2
    return 1
  fi
}

gh_release_id_for_tag() {
  local repo="$1"
  local tag="$2"

  need_cmd jq

  if ! gh_rest GET "/repos/$repo/releases" >/tmp/response; then
    echo "!!! Failed to find a release for tag $tag" >&2
    return 1
  fi

  jq ".[] | select(.tag_name == \"$tag\") | .id" </tmp/response
}

gh_release_upload_url_for_tag() {
  local repo="$1"
  local tag="$2"

  need_cmd jq
  need_cmd sed

  if ! gh_rest GET "/repos/$repo/releases/tags/$tag" >/tmp/response; then
    echo "!!! Failed to find a release for tag $tag" >&2
    return 1
  fi

  jq -r .upload_url </tmp/response | sed -E 's,\{.+\}$,,'
}

gh_rest() {
  local method="$1"
  shift
  local path="$1"
  shift

  gh_rest_raw "$method" "https://api.github.com$path" "$@"
}

gh_rest_raw() {
  local method="$1"
  shift
  local url="$1"
  shift

  need_cmd curl

  if [ -z "${GITHUB_TOKEN:-}" ]; then
    die "missing required environment variable: GITHUB_TOKEN"
  fi

  curl \
    --fail \
    --header "Authorization: token $GITHUB_TOKEN" \
    --header "Accept: application/vnd.github.v3+json" \
    -X "$method" \
    "$url" \
    "${@:---}"
}

gh_update_tag() {
  local repo="$1"
  local tag="$2"

  need_cmd git
  need_cmd jo

  local sha
  sha="$(git show -s --format=%H)"

  if gh_rest GET "/repos/$repo/git/refs/tags/$tag" >/dev/null 2>&1; then
    echo "--- Updating Git tag reference for '$tag'" >&2
    local payload
    payload="$(
      jo \
        sha="$sha" \
        force=true
    )"
    if ! gh_rest PATCH "/repos/$repo/git/refs/tags/$tag" --data "$payload" >/dev/null; then
      echo "!!! Failed to update Git tag reference for '$tag'" >&2
      return 1
    fi
  else
    echo "--- Creating Git tag reference for '$tag'" >&2
    local payload
    payload="$(
      jo \
        sha="$sha" \
        ref="refs/tags/$tag"
    )"
    if ! gh_rest POST "/repos/$repo/git/refs" --data "$payload" >/dev/null; then
      echo "!!! Failed to create Git tag reference for '$tag'" >&2
      return 1
    fi
  fi
}

gh_upload() {
  local url="$1"
  local artifact_file="$2"

  need_cmd basename

  if [ ! -f "$artifact_file" ]; then
    echo "!!! Artifact file '$artifact_file' not found, cannot upload" >&2
    return 1
  fi

  local artifact content_type
  artifact="$(basename "$artifact_file")"
  content_type="application/octet-stream"

  echo "--- Publishing artifact '$artifact' to $url" >&2

  gh_rest_raw POST "$url?name=$artifact" \
    --header "Content-Type: $content_type" \
    --data-binary "@$artifact_file"
}

gh_upload_all() {
  local url="$1"
  local dir="$2"

  find "$dir" -type f | while read -r artifact_file; do
    if ! gh_upload "$url" "$artifact_file"; then
      echo "!!! Failed to upload '$artifact_file'" >&2
      return 1
    fi
  done
}

die() {
  echo "" >&2
  echo "xxx $1" >&2
  echo "" >&2
  exit 1
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    die "Required command '$1' not found on PATH"
  fi
}

main "$@"
