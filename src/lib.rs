//! This crate provides a generate that constructs random name strings suitable
//! for use in container instances, project names, application instances, etc.
//!
//! The name `Generator` implements the `Iterator` trait so it can be used with
//! adapters, consumers, and in loops.
//!
//! # Usage
//!
//! This crate is [on crates.io](https://crates.io/crates/names) and can be
//! used by adding `names` to your dependencies in your project's `Cargo.toml`
//! file:
//!
//! ```toml
//! [dependencies]
//! names = "0.9.0"
//! ```
//!
//! and this to your crate root:
//!
//! ```
//! extern crate names;
//! ```
//!
//! # Example: painless defaults
//!
//! The easiest way to get started is to use the default `Generator` to return
//! a name:
//!
//! ```
//! use names::Generator;
//!
//! let mut generator: Generator = Default::default();
//! println!("Your project is: {}", generator.next().unwrap());
//! // #=> "Your project is: rusty-nail"
//! ```
//!
//! If more randomness is required, you can generate a name with a trailing
//! 4-digit number:
//!
//! ```
//! use names::{Generator, Name};
//!
//! let mut generator = Generator::with_naming(Name::Numbered);
//! println!("Your project is: {}", generator.next().unwrap());
//! // #=> "Your project is: pushy-pencil-5602"
//! ```
//!
//! # Example: with custom dictionaries
//!
//! If you would rather supply your own custom adjective and noun word lists,
//! you can provide your own by supplying 2 string slices. For example,
//! this returns only one result:
//!
//! ```
//! use names::Generator;
//!
//! let adjectives = &["imaginary"];
//! let nouns = &["roll"];
//! let mut generator = Generator::new(adjectives, nouns, Default::default());
//!
//! assert_eq!("imaginary-roll", generator.next().unwrap());
//! ```

extern crate rand;

use rand::Rng;

mod adjectives;
mod nouns;

/// A naming strategy for the `Generator`
pub enum Name {
    /// This represents a plain naming strategy of the form `"ADJECTIVE-NOUN"`
    Plain,
    /// This represents a naming strategy with a random number appended to the
    /// end, of the form `"ADJECTIVE-NOUN-NUMBER"`
    Numbered,
}

impl Default for Name {
    fn default() -> Name {
        Name::Plain
    }
}

/// A random name generator which combines an adjective, a noun, and an
/// optional number
///
/// A `Generator` takes a slice of adjective and noun words strings and has
/// a naming strategy (with or without a number appended).
pub struct Generator<'a> {
    adjectives: &'a [&'a str],
    nouns: &'a [&'a str],
    naming: Name,
}

impl<'a> Generator<'a> {
    /// Constructs a new `Generator<'a>`
    ///
    /// # Examples
    ///
    /// ```
    /// use names::{Generator, Name};
    ///
    /// let adjectives = &["sassy"];
    /// let nouns = &["clocks"];
    /// let naming = Name::Plain;
    ///
    /// let mut generator = Generator::new(adjectives, nouns, naming);
    ///
    /// assert_eq!("sassy-clocks", generator.next().unwrap());
    /// ```
    pub fn new(adjectives: &'a [&'a str], nouns: &'a [&'a str], naming: Name) -> Generator<'a> {
        Generator {
            adjectives: adjectives,
            nouns: nouns,
            naming: naming,
        }
    }

    /// Construct and returns a default `Generator<'a>` containing a large
    /// collection of adjectives and nouns
    ///
    /// ```
    /// use names::{Generator, Name};
    ///
    /// let mut generator = Generator::with_naming(Name::Plain);
    ///
    /// println!("My new name is: {}", generator.next().unwrap());
    /// ```
    pub fn with_naming(naming: Name) -> Generator<'a> {
        Generator::new(adjectives::LIST, nouns::LIST, naming)
    }

    fn rand_adj(&self) -> &str {
        rand::thread_rng().choose(self.adjectives).unwrap()
    }

    fn rand_noun(&self) -> &str {
        rand::thread_rng().choose(self.nouns).unwrap()
    }

    fn rand_num(&self) -> u16 {
        rand::thread_rng().gen_range(1, 10000)
    }
}

impl<'a> Default for Generator<'a> {
    fn default() -> Generator<'a> {
        Generator::new(adjectives::LIST, nouns::LIST, Default::default())
    }
}

impl<'a> Iterator for Generator<'a> {
    type Item = String;

    fn next(&mut self) -> Option<String> {
        let adj = self.rand_adj();
        let noun = self.rand_noun();

        Some(match self.naming {
            Name::Plain => format!("{}-{}", adj, noun),
            Name::Numbered => format!("{}-{}-{:04}", adj, noun, self.rand_num()),
        })
    }
}
