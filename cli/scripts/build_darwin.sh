#!/usr/bin/env bash
set -eu
if [ -n "${DEBUG:-}" ]; then set -x; fi

if [ "$(uname)" != "Darwin" ]; then
  echo ">>> $0 must be executed on Darwin platform, aborting"
  exit 11
fi

VERSION="${1:-${VERSION}}"

echo "--> Building Darwin release artifact version $VERSION"
pushd $(dirname $0)/../../
PLATFORM="$(uname | tr [[:upper:]] [[:lower:]])_$(uname -m)"
BIN=target/release/names
cd cli
cargo build --verbose --release
strip "$BIN"
ZIPFILE="$(pwd)/target/$(basename $BIN)_${VERSION}_$PLATFORM.zip"
(
  cd "$(dirname $BIN)"
  zip -9 "$ZIPFILE" "$(basename $BIN)"
)
cd $(dirname $ZIPFILE)
shasum -a 256 $(basename $ZIPFILE) >$(basename $ZIPFILE).sha256
popd
echo "--> Finished build Darwin release artifact version $VERSION."
