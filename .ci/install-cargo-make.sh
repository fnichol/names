#!/usr/bin/env sh
# shellcheck shell=sh disable=SC2039

print_usage() {
  local program="$1"

  echo "$program

    Installs cargo-make

    USAGE:
        $program [FLAGS] [--] [<VERSION>]

    FLAGS:
        -h, --help          Prints help information
            --print-latest  Prints the latest version of cargo-make

    ARGS:
        <VERSION>  Version to install which overrides the default of latest
    " | sed 's/^ \{1,4\}//g'
}

main() {
  set -eu
  if [ -n "${DEBUG:-}" ]; then set -v; fi
  if [ -n "${TRACE:-}" ]; then set -xv; fi

  local program version print_latest
  program="$(basename "$0")"
  version=""
  print_latest=""

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
          print-latest)
            print_latest=true
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
        die "invalid argument; arg=$arg"
        ;;
    esac
  done
  shift "$((OPTIND - 1))"

  local dest
  if [ -n "${CARGO_HOME:-}" ]; then
    dest="$CARGO_HOME/bin"
  elif [ -n "${HOME:-}" ]; then
    dest="$HOME/.cargo/bin"
  else
    die "cannot determine CARGO_HOME"
  fi

  if [ -n "${1:-}" ]; then
    version="$1"
    shift
  else
    version="$(latest_cargo_make_version)"
  fi

  if [ -n "$print_latest" ]; then
    echo "$version"
  else
    install_cargo_make "$version" "$dest"
  fi
}

latest_cargo_make_version() {
  local crate="cargo-make"

  cargo search --limit 1 --quiet "$crate" | head -n 1 | awk -F'"' '{print $2}'
}

install_cargo_make() {
  local version dest platform target file_base url archive
  version="$1"
  dest="$2"

  echo "--- Installing cargo-make $version to $dest"

  platform="$(uname -s)"
  case "$platform" in
    Darwin) target="x86_64-apple-darwin" ;;
    Linux) target="x86_64-unknown-linux-musl" ;;
    *) die "Platform '$platform' is not supported" ;;
  esac
  archive="$(mktemp 2>/dev/null || mktemp -t tmp)"
  file_base="cargo-make-v${version}-${target}"
  url="https://github.com/sagiegurari/cargo-make/releases/download/$version"
  url="$url/$file_base.zip"

  mkdir -p "$dest"
  echo "  - Downloading $url to $archive"
  curl -sSfL "$url" -o "$archive"
  echo "  - Extracting cargo-make into $dest"
  unzip -jo "$archive" "$file_base/cargo-make" -d "$dest"
  rm -f "$archive"
}

die() {
  echo "" >&2
  echo "xxx $1" >&2
  echo "" >&2
  exit 1
}

main "$@"
