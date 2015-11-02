# names

[![Build Status](https://travis-ci.org/fnichol/names.svg?branch=master)](https://travis-ci.org/fnichol/names) [![](http://meritbadge.herokuapp.com/names)](https://crates.io/crates/names) [![license](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/fnichol/names/blob/master/LICENSE-MIT)

Random name generator for Rust

* Crate: https://crates.io/crates/names
* Documentation http://fnichol.github.io/names/names/
* Source Code: https://github.com/fnichol/names

## Usage

This crate is [on crates.io](https://crates.io/crates/names) and can be
used by adding `names` to your dependencies in your project's `Cargo.toml`
file:

```toml
[dependencies]
names = "0.10.0"
```

and this to your crate root:

```rust
extern crate names;
```

### Example: Painless defaults

The easiest way to get started is to use the default `Generator` to return
a name:

```rust
use names::{Generator, Name};

fn main() {
    let mut generator = Generator::default(Name::Plain);

    println!("Your project is: {}", generator.next().unwrap());
    // #=> "Your project is: rusty-nail"
}
```

If more randomness is required, you can generate a name with a trailing
4-digit number:

```rust
use names::{Generator, Name};

fn main() {
    let mut generator = Generator::default(Name::Numbered);
    println!("Your project is: {}", generator.next().unwrap());
    // #=> "Your project is: pushy-pencil-5602"
}
```

# Example: with custom dictionaries

If you would rather supply your own custom adjective and noun word lists,
you can provide your own by supplying 2 string slices. For example,
this returns only one result:

```
use names::{Generator, Name};

fn main() {
    let adjectives = &["imaginary"];
    let nouns = &["roll"];
    let mut generator = Generator::new(adjectives, nouns, Name::Plain);

    assert_eq!("imaginary-roll", generator.next().unwrap());
}
```
