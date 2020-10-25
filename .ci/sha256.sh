#!/usr/bin/env sh
# shellcheck shell=sh disable=SC2039

print_usage() {
  local program="$1"

  echo "$program

    Generates a SHA256 digest for a file

    USAGE:
        $program [FLAGS] [--] <FILE>

    FLAGS:
        -h, --help      Prints help information

    ARGS:
        <FILE>  An input file
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
    die "missing <FILE> argument"
  fi
  local file="$1"
  shift
  if [ ! -f "$file" ]; then
    print_usage "$program" >&2
    die "file '$file' not found"
  fi

  build_sha256 "$file"
}

build_sha256() {
  local file="$1"

  need_cmd uname

  case "$(uname -s)" in
    FreeBSD)
      need_cmd sha256
      sha256 "$file" | sed -E 's/^.*\(([^)]+)\) = (.+)$/\2  \1/'
      ;;
    *)
      need_cmd shasum
      shasum -a 256 "$file"
      ;;
  esac
}

die() {
  echo "" >&2
  echo "xxx $1" >&2
  echo "" >&2
  return 1
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    die "Required command '$1' not found on PATH"
  fi
}

main "$@"
