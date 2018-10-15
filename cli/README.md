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
names 0.11.0

Author: Fletcher Nichol <fnichol@nichol.ca>

A random name generator with results like `delirious-pail'.

USAGE:
    names [FLAGS] [ARGS]

FLAGS:
    -h, --help       Prints help information
    -n, --number     Adds a random number to the name(s)
    -V, --version    Prints version information

ARGS:
    [amount]    Number of names to generate (default: 1)
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

## User feedback

### Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/fnichol/names/issues).

### Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/fnichol/names/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

## Authors

Created and maintained by [Fletcher Nichol](https://github.com/fnichol) (<fnichol@nichol.ca>)

## License

MIT (see [LICENSE-MIT](https://github.com/fnichol/names/blob/master/LICENSE-MIT))
