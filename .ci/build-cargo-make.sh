#!/usr/bin/env sh
# shellcheck shell=sh disable=SC2039

print_usage() {
  local program="$1"

  echo "$program

    Builds cargo-make into a dedicated directory for caching

    USAGE:
        $program [FLAGS] [--] <PLUGIN>

    FLAGS:
        -h, --help      Prints help information

    ARGS:
        <PLUGIN>  Name of the Cargo plugin
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

  local dest
  if [ -n "${CARGO_HOME:-}" ]; then
    dest="$CARGO_HOME"
  elif [ -n "${HOME:-}" ]; then
    dest="$HOME/.cargo"
  else
    die "cannot determine CARGO_HOME"
  fi

  install_cargo_make "$dest"
}

install_cargo_make() {
  local dest="$1"
  local plugin="cargo-make"

  echo "--- Building $plugin in $dest"

  mkdir -p "$dest"
  rustup install stable
  cargo +stable install --root "$dest/opt/$plugin" --force --verbose "$plugin"

  # Create symbolic links for all execuatbles into $CARGO_HOME/bin
  ln -snf "$dest/opt/$plugin/bin"/* "$dest/bin/"
}

die() {
  echo "" >&2
  echo "xxx $1" >&2
  echo "" >&2
  return 1
}

main "$@"
