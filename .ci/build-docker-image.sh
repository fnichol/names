#!/usr/bin/env sh
# shellcheck shell=sh disable=SC2039

print_usage() {
  local program="$1"

  echo "$program

    Builds a Docker image

    USAGE:
        $program [FLAGS] [--] <IMG> <VERSION> <REPO> <AUTHOR> <LICENSE> <BIN> <ARCHIVE>

    FLAGS:
        -h, --help          Prints help information

    ARGS:
        <ARCHIVE> Tarball archive [example: names-x86_64-linux-musl.tar.gz]
        <AUTHOR>  Author names [example: Jane Doe <jdoe@example.com]
        <BIN>     Name of the program [example: names]
        <IMG>     Name of Docker Hub image [example: jdoe/names]
        <LICENSE> License for project [example: MPL-2.0]
        <REPO>    Name of GitHub repository [example: jdoe/names-rs]
        <VERSION> Version to install and tag [example: 1.0.1]
    " | sed 's/^ \{1,4\}//g'
}

main() {
  set -eu
  if [ -n "${DEBUG:-}" ]; then set -v; fi
  if [ -n "${TRACE:-}" ]; then set -xv; fi

  local program img version repo author license bin archive
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
        die "invalid argument; arg=$arg"
        ;;
    esac
  done
  shift "$((OPTIND - 1))"

  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <IMG> argument"
  fi
  img="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <VERSION> argument"
  fi
  version="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <REPO> argument"
  fi
  repo="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <AUTHOR> argument"
  fi
  author="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <LICENSE> argument"
  fi
  license="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <BIN> argument"
  fi
  bin="$1"
  shift
  if [ -z "${1:-}" ]; then
    print_usage "$program" >&2
    die "missing <ARCHIVE> argument"
  fi
  archive="$1"
  shift

  if [ ! -f "$archive" ]; then
    print_usage "$program" >&2
    die "archive file does not exist: '$archive'"
  fi
  if [ ! -f "$archive.sha256" ]; then
    print_usage "$program" >&2
    die "archive checksum file does not exist: '$archive.sha256'"
  fi

  build_docker_image \
    "$img" "$version" "$repo" "$author" "$license" "$bin" "$archive"
}

build_docker_image() {
  local img="$1"
  local version="$2"
  local repo="$3"
  local author="$4"
  local license="$5"
  local bin="$6"
  local archive="$7"

  need_cmd basename
  need_cmd date
  need_cmd dirname
  need_cmd docker
  need_cmd git
  need_cmd grep
  need_cmd shasum
  need_cmd tar

  local full_name
  full_name="$(basename "$archive")"
  full_name="${full_name%%.tar.gz}"

  echo "--- Building a Docker image $img:$version for '$bin'"

  local workdir
  workdir="$(mktemp -d 2>/dev/null || mktemp -d -t tmp)"
  setup_traps "cleanup $workdir"

  local revision created
  revision="$(git show -s --format=%H)"
  created="$(date -u +%FT%TZ)"

  cd "$(dirname "$archive")"
  echo "  - Verifying $archive"
  shasum -a 256 -c "$archive.sha256"

  cd "$workdir"
  echo "  - Extracting $bin from $archive"
  tar xf "$archive"
  mv "$full_name" "$bin"

  echo "  - Generating image metadata"
  cat <<-END >image-metadata
	img="$img"
	version="$version"
	source="http://github.com/$repo.git"
	revision="$revision"
	created="$created"
	END

  echo "  - Generating Dockerfile"
  cat <<-END >Dockerfile
	FROM scratch
  LABEL \
    name="$img" \
    org.opencontainers.image.version="$version" \
    org.opencontainers.image.authors="$author" \
    org.opencontainers.image.licenses="$license" \
    org.opencontainers.image.source="http://github.com/$repo.git" \
    org.opencontainers.image.revision="$revision" \
    org.opencontainers.image.created="$created"
	ADD $bin /$bin
	ADD image-metadata /etc/image-metadata
	ENTRYPOINT ["/$bin"]
	END

  echo "  - Building image $img:$version"
  docker build -t "$img:$version" .
  if echo "$version" | grep -q -E '^\d+\.\d+.\d+$'; then
    docker tag "$img:$version" "$img:latest"
  fi
}

# See: https://git.io/JtdlJ
setup_traps() {
  local trap_fun
  trap_fun="$1"

  local sig
  for sig in HUP INT QUIT ALRM TERM; do
    trap "
      $trap_fun
      trap - $sig EXIT
      kill -s $sig "'"$$"' "$sig"
  done

  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "zshexit() { eval '$trap_fun'; }"
  else
    # shellcheck disable=SC2064
    trap "$trap_fun" EXIT
  fi
}

cleanup() {
  local workdir="$1"

  if [ -d "$workdir" ]; then
    echo "  - Cleanup up Docker context $workdir"
    rm -rf "$workdir"
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
