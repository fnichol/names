# names - cli

[![Build Status](https://travis-ci.org/fnichol/names.svg?branch=master)](https://travis-ci.org/fnichol/names) [![license](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/fnichol/names/blob/master/LICENSE-MIT)

Random name generator tool that gives you Heroku or Docker-style names.

## Usage

Simple! Run without any parameters, you get a name:

```sh
> names
selfish-change
```

Need more? Tell it how many:

```sh
> names 10
rustic-flag
nondescript-crayon
picayune-map
elderly-cough
skinny-jeans
neat-rock
aware-sponge
psychotic-coast
brawny-event
tender-oatmeal
```

Not random enough? How about adding a 4-number pad:

```sh
> names --number 5
imported-rod-9680
thin-position-2344
hysterical-women-5647
volatile-pen-9210
diligent-grip-4520
```

If you're ever confused, at least there's help:

```sh
> names --help
names 0.10.0

Author: Fletcher Nichol <fnichol@nichol.ca>

A random name generator with results like `delirious-pail'.

USAGE:
        names [FLAGS] [ARGS]

FLAGS:
    -h, --help       Prints help information
    -n, --number     Adds a random number to the name(s)
    -V, --version    Prints version information

ARGS:
    amount    Number of names to generate (default: 1)
```

## Installation

### GitHub releases

There are binary builds for Mac OS X (referred to as "Darwin") and Linux (a small, self-contained static binary) available through the project's [GitHub releases](https://github.com/fnichol/names/releases).

### Docker images

If Docker is more your speed, there's a speedy teeny tiny image (~1MB) on the Docker hub at [fnichol/names](https://hub.docker.com/r/fnichol/names/). It's pretty easy to get started:

```sh
> docker run fnichol/names 4
furtive-polish
modern-business
alive-sun
tremendous-line
```

### Building from source

If you want (or need) to build the CLI from source, the following should not take too long. Note that you'll need a version of Rust (and Cargo which ships with the Rust distributions) before running:

```sh
> git clone https://github.com/fnichol/names.git
> cd names/cli
> cargo build --release
# test it out
> ./target/release/names
```

#### A static binary on Linux?

This project was used by its author to experiment with producing static binaries on Linux from a Rust project that has no external dependencies. This was done using a special build of Rust that supports the [musl](http://www.musl-libc.org/) libc project, available via the [fnichol/rust:1.4.0-musl](https://hub.docker.com/r/fnichol/rust/) Docker image. Here's an example building the CLI to a static ELF binary on Linux:

```sh
> git clone https://github.com/fnichol/names.git
> cd names
> docker run --rm -ti -v `pwd`:/src -w /src/cli fnichol/rust:1.4.0-musl \
    cargo build --release --target=x86_64-unknown-linux-musl

> docker run --rm -ti -v `pwd`:/src fnichol/rust:1.4.0-musl \
    du -h ./cli/target/x86_64-unknown-linux-musl/release/names
1.5M    ./cli/target/x86_64-unknown-linux-musl/release/names

> docker run --rm -ti -v `pwd`:/src fnichol/rust:1.4.0-musl \
    ldd ./cli/target/x86_64-unknown-linux-musl/release/names
        not a dynamic executable

> docker run --rm -ti -v `pwd`:/src fnichol/rust:1.4.0-musl \
    file ./cli/target/x86_64-unknown-linux-musl/release/names
./cli/target/x86_64-unknown-linux-musl/release/names: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, BuildID[sha1]=6ad327ca3a5b21c42fa158832d89f6e9b0fc8e73, not stripped
```

A variant of this approach is used in the [build_linux.sh](https://github.com/fnichol/names/blob/master/cli/scripts/build_linux.sh) script, which additional strips the binary and produces a Zip archive and SHA 256 checksum:


```sh
> git clone https://github.com/fnichol/names.git
> cd names
> ./cli/scripts/build_linux.sh 0.10.0

> du -h ./cli/target/x86_64-unknown-linux-musl/release/names
996K    ./cli/target/x86_64-unknown-linux-musl/release/names

> file ./cli/target/x86_64-unknown-linux-musl/release/names
./cli/target/x86_64-unknown-linux-musl/release/names: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, stripped

> du -csh ./cli/target/names*.zip*
396K    cli/target/names_0.10.0_linux_x86_64.zip
4.0K    cli/target/names_0.10.0_linux_x86_64.zip.sha256
400K    total
```

## User feedback

### Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/fnichol/names/issues).

### Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/fnichol/names/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

## Authors

Created and maintained by [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>)

## License

MIT (see [LICENSE-MIT](https://github.com/fnichol/names/blob/master/LICENSE-MIT))
