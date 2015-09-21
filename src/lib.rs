//! This crate provides a generate that constructs random name strings suitable
//! for use in container instances, project names, application instances, etc.
//!
//! # Usage
//!
//! This crate is [on crates.io](https://crates.io/crates/names) and can be
//! used by adding `names` to your dependencies in your project's `Cargo.toml`
//! file:
//!
//! ```toml
//! [dependencies]
//! names = "0.1.0"
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
//! let generator = Generator::default();
//! println!("Your project is: {}", generator.name());
//! // #=> "rusty-nail"
//! ```
//!
//! If more randomness is required, you can generate a name with a trailing
//! 4-digit number:
//!
//! ```
//! use names::Generator;
//!
//! let generator = Generator::default();
//! println!("Your project is: {}", generator.name_with_number());
//! // #=> "pushy-pencil-5602"
//! ```
//!
//! # Example: with custom dictionaries
//!
//! If you would rather supply your own custom adjective and noun word lists,
//! you can provide your own by supplying 2 `Dictionary` structs. For example,
//! this returns only one result:
//!
//! ```
//! use names::{Dictionary, Generator};
//!
//! let adjectives = &["imaginary"];
//! let nouns = &["roll"];
//! let generator = Generator::new(
//!     Dictionary::new(adjectives),
//!     Dictionary::new(nouns));
//!
//! assert_eq!("imaginary-roll", generator.name());
//! ```

extern crate rand;

use rand::Rng;

mod adjectives;
mod nouns;

/// A `Dictionary` is collection of words.
pub struct Dictionary<'a> {
    words: &'a [&'a str],
}

impl<'a> Dictionary<'a> {
    pub fn new(words: &'a [&'a str]) -> Dictionary<'a> {
        Dictionary { words: words }
    }

    pub fn random(&self) -> &str {
        rand::thread_rng().choose(self.words).unwrap()
    }
}

/// A random name generator which combines an adjective, a noun, and an
/// optional number.
///
/// A `Generator` takes a `Dictionary` of adjectives and a `Dictionary` of
/// nouns.
pub struct Generator<'a> {
    adjectives: Dictionary<'a>,
    nouns: Dictionary<'a>,
}

impl<'a> Generator<'a> {
    /// Constructs a new `Generator<'a>`.
    ///
    /// # Examples
    ///
    /// ```
    /// use names::{Dictionary, Generator};
    ///
    /// let adjective_words = &["sassy"];
    /// let noun_words = &["clocks"];
    ///
    /// let adjectives = Dictionary::new(adjective_words);
    /// let nouns = Dictionary::new(noun_words);
    ///
    /// let generator = Generator::new(adjectives, nouns);
    ///
    /// assert_eq!("sassy-clocks", generator.name());
    /// ```
    pub fn new(adjectives: Dictionary<'a>, nouns: Dictionary<'a>) -> Generator<'a> {
        Generator { adjectives: adjectives, nouns: nouns }
    }

    /// Construct and returns a default `Generator<'a>` containing a large
    /// collection of adjectives and nouns.
    ///
    /// ```
    /// use names::Generator;
    ///
    /// let generator = Generator::default();
    ///
    /// println!("My new name is: {}", generator.name());
    /// ```
    pub fn default() -> Generator<'a> {
        Generator::new(
            Dictionary::new(adjectives::LIST),
            Dictionary::new(nouns::LIST))
    }

    pub fn name(&self) -> String {
        format!("{}-{}", self.adjectives.random(), self.nouns.random())
    }

    pub fn name_with_number(&self) -> String {
        format!("{}-{}-{:04}",
                self.adjectives.random(),
                self.nouns.random(),
                rand::thread_rng().gen_range(1, 10000))
    }
}
