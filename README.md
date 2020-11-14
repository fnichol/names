# names

|                  |                                                         |
| ---------------: | ------------------------------------------------------- |
|               CI | [![CI Status][badge-ci-overall]][ci]                    |
|   Latest Version | [![Latest version][badge-version]][crate]               |
|    Documentation | [![Documentation][badge-docs]][docs]                    |
|  Crate Downloads | [![Crate downloads][badge-crate-dl]][crate]             |
| GitHub Downloads | [![Github downloads][badge-github-dl]][github-releases] |
|     Docker Pulls | [![Docker pulls][badge-docker-pulls]][docker]           |
|          License | [![Crate license][badge-license]][github]               |

**Table of Contents**

<!-- toc -->

- [CLI](#cli)
- [CLI Usage](#cli-usage)
- [CLI Installation](#cli-installation)
  - [GitHub releases](#github-releases)
  - [Docker images](#docker-images)
  - [Building from source](#building-from-source)
- [Library](#library)
- [Library Usage](#library-usage)
- [Library Examples](#library-examples)
  - [Example: painless defaults](#example-painless-defaults)
  - [Example: with custom dictionaries](#example-with-custom-dictionaries)
- [CI Status](#ci-status)
  - [Build (master branch)](#build-master-branch)
  - [Test (master branch)](#test-master-branch)
  - [Check (master branch)](#check-master-branch)
- [Code of Conduct](#code-of-conduct)
- [Issues](#issues)
- [Contributing](#contributing)
- [Release History](#release-history)
- [Authors](#authors)
- [License](#license)

<!-- tocstop -->

## CLI

## CLI Usage

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

## CLI Installation

### GitHub releases

There are binary builds for Mac OS X (referred to as "Darwin") and Linux (a
small, self-contained static binary) available through the project's
[GitHub releases](https://github.com/fnichol/names/releases).

### Docker images

If Docker is more your speed, there's a speedy teeny tiny image (~1MB) on the
Docker hub at [fnichol/names](https://hub.docker.com/r/fnichol/names/). It's
pretty easy to get started:

```sh
> docker run fnichol/names 4
furtive-polish
modern-business
alive-sun
tremendous-line
```

### Building from source

If you want (or need) to build the CLI from source, the following should not
take too long. Note that you'll need a version of Rust (and Cargo which ships
with the Rust distributions) before running:

```sh
> git clone https://github.com/fnichol/names.git
> cd names/cli
> cargo build --release
# test it out
> ./target/release/names
```

---

## Library

This crate provides a generate that constructs random name strings suitable for
use in container instances, project names, application instances, etc.

The name `Generator` implements the `Iterator` trait so it can be used with
adapters, consumers, and in loops.

## Library Usage

This crate is [on crates.io](https://crates.io/crates/names) and can be used by
adding `names` to your dependencies in your project's `Cargo.toml` file:

```toml
[dependencies]
names = { version = "0.11.1-dev", default-features = false }
```

## Library Examples

### Example: painless defaults

The easiest way to get started is to use the default `Generator` to return a
name:

```rust
use names::Generator;

let mut generator = Generator::default();
println!("Your project is: {}", generator.next().unwrap());
// #=> "Your project is: rusty-nail"
```

If more randomness is required, you can generate a name with a trailing 4-digit
number:

```rust
use names::{Generator, Name};

let mut generator = Generator::with_naming(Name::Numbered);
println!("Your project is: {}", generator.next().unwrap());
// #=> "Your project is: pushy-pencil-5602"
```

### Example: with custom dictionaries

If you would rather supply your own custom adjective and noun word lists, you
can provide your own by supplying 2 string slices. For example, this returns
only one result:

```rust
use names::{Generator, Name};

let adjectives = &["imaginary"];
let nouns = &["roll"];
let mut generator = Generator::new(adjectives, nouns, Name::default());

assert_eq!("imaginary-roll", generator.next().unwrap());
```

## CI Status

### Build (master branch)

| Operating System | Target                        | Stable Rust                                                                    |
| ---------------: | ----------------------------- | ------------------------------------------------------------------------------ |
|          FreeBSD | `x86_64-unknown-freebsd`      | [![FreeBSD Build Status][badge-ci-build-x86_64-unknown-freebsd]][ci-master]    |
|            Linux | `arm-unknown-linux-gnueabihf` | [![Linux Build Status][badge-ci-build-arm-unknown-linux-gnueabihf]][ci-master] |
|            Linux | `aarch64-unknown-linux-gnu`   | [![Linux Build Status][badge-ci-build-aarch64-unknown-linux-gnu]][ci-master]   |
|            Linux | `i686-unknown-linux-gnu`      | [![Linux Build Status][badge-ci-build-i686-unknown-linux-gnu]][ci-master]      |
|            Linux | `i686-unknown-linux-musl`     | [![Linux Build Status][badge-ci-build-i686-unknown-linux-musl]][ci-master]     |
|            Linux | `x86_64-unknown-linux-gnu`    | [![Linux Build Status][badge-ci-build-x86_64-unknown-linux-gnu]][ci-master]    |
|            Linux | `x86_64-unknown-linux-musl`   | [![Linux Build Status][badge-ci-build-x86_64-unknown-linux-musl]][ci-master]   |
|            macOS | `x86_64-apple-darwin`         | [![macOS Build Status][badge-ci-build-x86_64-apple-darwin]][ci-master]         |
|          Windows | `x86_64-pc-windows-msvc`      | [![Windows Build Status][badge-ci-build-x86_64-pc-windows-msvc]][ci-master]    |

### Test (master branch)

| Operating System | Stable Rust                                                              | Nightly Rust                                                               | <abbr title="Minimum Supported Rust Version">MSRV</abbr>             |
| ---------------: | ------------------------------------------------------------------------ | -------------------------------------------------------------------------- | -------------------------------------------------------------------- |
|          FreeBSD | [![FreeBSD Stable Test Status][badge-ci-test-stable-freebsd]][ci-master] | [![FreeBSD Nightly Test Status][badge-ci-test-nightly-freebsd]][ci-master] | [![FreeBSD MSRV Test Status][badge-ci-test-msrv-freebsd]][ci-master] |
|            Linux | [![Linux Stable Test Status][badge-ci-test-stable-linux]][ci-master]     | [![Linux Nightly Test Status][badge-ci-test-nightly-linux]][ci-master]     | [![Linux MSRV Test Status][badge-ci-test-msrv-linux]][ci-master]     |
|            macOS | [![macOS Stable Test Status][badge-ci-test-stable-macos]][ci-master]     | [![macOS Nightly Test Status][badge-ci-test-nightly-macos]][ci-master]     | [![macOS MSRV Test Status][badge-ci-test-msrv-macos]][ci-master]     |
|          Windows | [![Windows Stable Test Status][badge-ci-test-stable-windows]][ci-master] | [![Windows Nightly Test Status][badge-ci-test-nightly-windows]][ci-master] | [![Windows MSRV Test Status][badge-ci-test-msrv-windows]][ci-master] |

### Check (master branch)

|        | Status                                               |
| ------ | ---------------------------------------------------- |
| Lint   | [![Lint Status][badge-ci-check-lint]][ci-master]     |
| Format | [![Format Status][badge-ci-check-format]][ci-master] |

## Code of Conduct

This project adheres to the Contributor Covenant [code of
conduct][code-of-conduct]. By participating, you are expected to uphold this
code. Please report unacceptable behavior to fnichol@nichol.ca.

## Issues

If you have any problems with or questions about this project, please contact us
through a [GitHub issue][issues].

## Contributing

You are invited to contribute to new features, fixes, or updates, large or
small; we are always thrilled to receive pull requests, and do our best to
process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub
issue][issues], especially for more ambitious contributions. This gives other
contributors a chance to point you in the right direction, give you feedback on
your design, and help you find out if someone else is working on the same thing.

## Release History

See the [changelog] for a full release history.

## Authors

Created and maintained by [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>).

## License

Licensed under the MIT license ([LICENSE.txt][license]).

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the MIT license, shall be
licensed as above, without any additional terms or conditions.

[badge-ci-build-x86_64-unknown-freebsd]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-x86_64-unknown-freebsd
[badge-ci-build-arm-unknown-linux-gnueabihf]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-arm-unknown-linux-gnueabihf
[badge-ci-build-aarch64-unknown-linux-gnu]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-aarch64-unknown-linux-gnu
[badge-ci-build-i686-unknown-linux-gnu]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-i686-unknown-linux-gnu
[badge-ci-build-i686-unknown-linux-musl]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-i686-unknown-linux-musl
[badge-ci-build-x86_64-unknown-linux-gnu]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-x86_64-unknown-linux-gnu
[badge-ci-build-x86_64-unknown-linux-musl]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-x86_64-unknown-linux-musl
[badge-ci-build-x86_64-apple-darwin]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-x86_64-apple-darwin
[badge-ci-build-x86_64-pc-windows-msvc]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=bin-build-names-x86_64-pc-windows-msvc
[badge-ci-check-format]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=check&script=format
[badge-ci-check-lint]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=check&script=lint
[badge-ci-overall]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square
[badge-ci-test-msrv-freebsd]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-msrv-x86_64-unknown-freebsd
[badge-ci-test-msrv-linux]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-msrv-x86_64-unknown-linux-gnu
[badge-ci-test-msrv-macos]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-msrv-x86_64-apple-darwin
[badge-ci-test-msrv-windows]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-msrv-x86_64-pc-windows-msvc
[badge-ci-test-nightly-freebsd]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-nightly-x86_64-unknown-freebsd
[badge-ci-test-nightly-linux]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-nightly-x86_64-unknown-linux-gnu
[badge-ci-test-nightly-macos]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-nightly-x86_64-apple-darwin
[badge-ci-test-nightly-windows]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-nightly-x86_64-pc-windows-msvc
[badge-ci-test-stable-freebsd]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-stable-x86_64-unknown-freebsd
[badge-ci-test-stable-linux]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-stable-x86_64-unknown-linux-gnu
[badge-ci-test-stable-macos]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-stable-x86_64-apple-darwin
[badge-ci-test-stable-windows]:
  https://img.shields.io/cirrus/github/fnichol/names.svg?style=flat-square&task=test-stable-x86_64-pc-windows-msvc
[badge-crate-dl]: https://img.shields.io/crates/d/names.svg?style=flat-square
[badge-docker-pulls]:
  https://img.shields.io/docker/pulls/fnichol/names.svg?style=flat-square
[badge-docs]: https://docs.rs/names/badge.svg?style=flat-square
[badge-github-dl]:
  https://img.shields.io/github/downloads/fnichol/names/total.svg
[badge-license]: https://img.shields.io/crates/l/names.svg?style=flat-square
[badge-version]: https://img.shields.io/crates/v/names.svg?style=flat-square
[changelog]: https://github.com/fnichol/names/blob/master/names/CHANGELOG.md
[ci]: https://cirrus-ci.com/github/fnichol/names
[ci-master]: https://cirrus-ci.com/github/fnichol/names/master
[code-of-conduct]:
  https://github.com/fnichol/names/blob/master/names/CODE_OF_CONDUCT.md
[commonmark]: https://commonmark.org/
[crate]: https://crates.io/crates/names
[docker]: https://hub.docker.com/r/fnichol/names
[docs]: https://docs.rs/names
[fnichol]: https://github.com/fnichol
[github]: https://github.com/fnichol/names
[github-releases]: https://github.com/fnichol/names/releases
[issues]: https://github.com/fnichol/names/issues
[license]: https://github.com/fnichol/names/blob/master/names/LICENSE.txt
