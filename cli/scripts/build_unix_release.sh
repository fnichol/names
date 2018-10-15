#!/usr/bin/env bash

main() {
  set -euo pipefail
  if [ -n "${DEBUG:-}" ]; then set -x; fi

  program="$(basename "$0")"
  author="Fletcher Nichol <fnichol@nichol.ca>"

  need_cmd basename
  need_cmd cp
  need_cmd cut
  need_cmd dirname
  need_cmd grep
  need_cmd rustup
  need_cmd shasum
  need_cmd strip
  need_cmd tr
  need_cmd uname

  parse_cli_args "$@"

  build_release
}

print_help() {
  echo "$program

Authors: $author

Builds release artifacts for a supported system.

USAGE:
    $program [FLAGS] [OPTIONS]

FLAGS:
    -h    Prints help information

"
}

parse_cli_args() {
  OPTIND=1
  # Parse command line flags and options
  while getopts ":h" opt; do
    case $opt in
      h)
        print_help
        exit 0
        ;;
      \?)
        print_help
        exit_with "Invalid option:  -$OPTARG" 1
        ;;
    esac
  done
  # Shift off all parsed token in `$*` so that the subcommand is now `$1`.
  shift "$((OPTIND - 1))"
}

build_release() {
  local platform bin version dist_bin_file dist_sha_file target
  platform="$(uname -s | tr '[:upper:]' '[:lower:]')_$(uname -m)"

  banner "Building release artifacts for $platform"

  case "$platform" in
    linux_x86_64)
      target=x86_64-unknown-linux-musl
      ;;
    darwin_x86_64)
      target=x86_64-apple-darwin
      ;;
    *)
      exit_with "Unsupported platform '$platform', aborting" 10
      ;;
  esac
  if ! is_target_installed "$target"; then
    exit_with "Rustup target '$target' is not currently installed, aborting" 11
  fi

  bin="target/$target/release/names"

  pushd "$(dirname "$0")/../" >/dev/null

  info "Compiling $(basename "$bin")"
  rustup run stable cargo clean --verbose --release --target="$target"
  rustup run stable cargo build --verbose --release --target="$target"

  info "Stripping binary $bin"
  strip "$bin"

  version="$(get_version "$bin")"
  dist_bin_file="target/$(basename "$bin")_${version}_$platform"
  dist_sha_file="${dist_bin_file}.sha256"

  info "Copying binary to $dist_bin_file"
  cp -v "$bin" "$dist_bin_file"

  pushd "$(dirname "$dist_bin_file")" >/dev/null
  info "Calculating SHA256 in $dist_sha_file"
  shasum -a 256 "$(basename "$dist_bin_file")" >"$(basename "$dist_sha_file")"

  popd >/dev/null
  popd >/dev/null

  info "Finished building $platform artifacts for version $version."
}

get_version() {
  local bin="$1"
  "$bin" --version | cut -d ' ' -f 2
}

is_target_installed() {
  local target="$1"

  rustup target list |
    grep -E '\((default|installed)\)$' |
    cut -d ' ' -f 1 |
    grep -q "^$target\$" >/dev/null
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    exit_with "Required command '$1' not found on PATH" 127
  fi
}

banner() {
  echo "--> ${1:-}"
}

info() {
  echo "    ${1:-}"
}

warn() {
  echo "xxx ${1:-}" >&2
}

exit_with() {
  warn "$1"
  exit "${2:-10}"
}

main "$@"
