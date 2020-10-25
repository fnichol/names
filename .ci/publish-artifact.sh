#!/usr/bin/env sh
# shellcheck shell=sh disable=SC2039

print_usage() {
  local program="$1"

  echo "$program

    Uploads a release artifact for publishing

    USAGE:
        $program [FLAGS] [--] <REPO> <RELEASE> <ARTIFACT>

    FLAGS:
        -h, --help      Prints help information

    ARGS:
        <REPO>      Full name of the repo [ex: fnichol/names]
        <RELEASE>   GitHub ID of the release [ex: 23]
        <ARTIFACT>  An artifact file [ex: names-x86_64-unknown-linux-musl]
    " | sed 's/^ \{1,4\}//g'
}

main() {
  set -eu
  if [ -n "${DEBUG:-}" ]; then set -v; fi
  if [ -n "${TRACE:-}" ]; then set -xv; fi

  local program
  program="$(basename "$0")"

  OPTIND=1
  while getopts "h-:" arg; do
    case "$arg" in
      h)
        print_usage "$program"
        return 0
        ;;
      -)
        case "$OPTARG" in
          help)
            print_usage "$program"
            return 0
            ;;
          '')
            # "--" terminates argument processing
            break
            ;;
          *)
            print_usage "$program" >&2
            die "invalid argument --$OPTARG"
            ;;
        esac
        ;;
      \?)
        print_usage "$program" >&2
        die "invalid argument; arg=-$OPTARG"
        ;;
    esac
  done
  shift "$((OPTIND - 1))"

  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <REPO> argument"
  fi
  local repo="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <RELEASE> argument"
  fi
  local release="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <ARTIFACT> argument"
  fi
  local artifact="$1"
  shift
  if [ ! -f "$artifact" ]; then
    print_usage "$program" >&2
    die "artifact '$artifact' not found"
  fi

  if [ -z "${GITHUB_TOKEN:-}" ]; then
    die "missing required environment variable: GITHUB_TOKEN"
  fi

  upload_artifact "$repo" "$release" "$artifact"
}

upload_artifact() {
  local repo="$1"
  local release="$2"
  local artifact_file="$3"

  need_cmd basename
  need_cmd curl

  local artifact content_type
  artifact="$(basename "$artifact_file")"
  content_type="application/octet-stream"

  echo "--- Publishing artifact '$artifact' to the '$release' release"

  local url
  url="https://uploads.github.com/repos/$repo/releases/$release"
  url="$url/assets?name=$artifact"

  echo "  - Uploading '$artifact_file' to $url"
  local code
  code="$(curl \
    -X POST \
    --data-binary "@$artifact_file" \
    --header "Authorization: token $GITHUB_TOKEN" \
    --header "Content-Type: $content_type" \
    -w '%{http_code}' \
    -o /dev/stderr \
    "$url")"

  if [ "$code" -ne 201 ]; then
    die "upload response was: $code"
  fi
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
