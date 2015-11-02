#!/usr/bin/env bash
set -eu
if [ -n "${DEBUG:-}" ]; then set -x; fi

if ! command -v docker >/dev/null; then
  echo ">>> $0 must be executed on a system with Docker installed, aborting"
  exit 11
fi

VERSION="${1:-${VERSION}}"

echo "--> Building Linux release artifact version $VERSION"
pushd `dirname $0`/../../
  docker run --rm -v `pwd`:/src -e VERSION=$VERSION fnichol/rust:1.4.0-musl \
    bash -c 'set -eux
      apt-get update
      apt-get install -y zip
      PLATFORM="`uname | tr [[:upper:]] [[:lower:]]`_`uname -m`"
      TARGET=x86_64-unknown-linux-musl
      BIN=target/$TARGET/release/names
      cd cli
      cargo build --verbose --release --target=$TARGET
      strip "$BIN"
      ZIPFILE="`pwd`/target/`basename $BIN`_${VERSION}_$PLATFORM.zip"
      (cd "`dirname $BIN`"; zip -9 "$ZIPFILE" "`basename $BIN`")
      cd `dirname $ZIPFILE`
      shasum -a 256 `basename $ZIPFILE` > `basename $ZIPFILE`.sha256
    '
popd
echo "--> Finished build Linux release artifact version $VERSION."
