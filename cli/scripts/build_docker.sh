#!/usr/bin/env bash
set -eu
if [ -n "${DEBUG:-}" ]; then set -x; fi

if ! command -v docker >/dev/null; then
  echo ">>> $0 must be executed on a system with Docker installed, aborting"
  exit 11
fi

on_exit() {
  if [ -d "${docker_context:-}" ]; then
    echo "Cleaning up Docker context $docker_context"
    rm -rf "$docker_context"
  fi
}

trap on_exit 1 2 3 15 ERR

VERSION="${1:-${VERSION}}"
docker_context="`mktemp -d -t build_docker-XXXX`"
repo="fnichol/names"
github_repo="https://github.com/$repo/releases/download"

echo "--> Building Docker release artifact version $VERSION"
pushd "$docker_context"
  curl -fsSLO \
    "$github_repo/v${VERSION}/names_${VERSION}_linux_x86_64.zip"
  curl -fsSLO \
    "$github_repo/v${VERSION}/names_${VERSION}_linux_x86_64.zip.sha256"
  shasum -a 256 -c names_*.zip.sha256
  unzip names_*.zip
  rm -f names_*.zip

  cat <<_DOCKERFILE_ >Dockerfile
FROM scratch
MAINTAINER Fletcher Nichol <fnichol@nichol.ca>
ADD names /names
ENTRYPOINT ["/names"]
CMD ["--help"]
_DOCKERFILE_

  docker build -t "$repo:$VERSION" .
  if [ -n "${LATEST:-}" ]; then docker build -t "$repo:latest" .; fi
popd
echo "--> Finished build Docker release artifact version $VERSION."
