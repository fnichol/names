//! This crate provides a generate that constructs random name strings suitable
//! for use in container instances, project names, application instances, etc.
//!
//! The name `Generator` implements the `Iterator` trait so it can be used with
//! adapters, consumers, and in loops.
//!
//! ## Usage
//!
//! This crate is [on crates.io](https://crates.io/crates/names) and can be
//! used by adding `names` to your dependencies in your project's `Cargo.toml`
//! file:
//!
//! ```toml
//! [dependencies]
//! names = { version = "0.15.0", default-features = false }
//! ```
//! ## Examples
//!
//! ### Example: painless defaults
//!
//! The easiest way to get started is to use the default `Generator` to return
//! a name:
//!
//! ```
//! use names::Generator;
//!
//! let mut generator = Generator::default();
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
//! ### Example: with custom dictionaries
//!
//! If you would rather supply your own custom adjective and noun word lists,
//! you can provide your own by supplying 2 string slices. For example,
//! this returns only one result:
//!
//! ```
//! use names::{Generator, Name};
//!
//! let adjectives = &["imaginary"];
//! let nouns = &["roll"];
//! let mut generator = Generator::new(adjectives, nouns, Name::default());
//!
//! assert_eq!("imaginary-roll", generator.next().unwrap());
//! ```

#![doc(html_root_url = "https://docs.rs/names/0.15.0-dev")]
#![deny(missing_docs)]

use inflector::Inflector;
use rand::{rngs::ThreadRng, seq::SliceRandom, Rng};
use std::str::FromStr;

/// List of English adjective words
pub const ADJECTIVES: &[&str] = &include!(concat!(env!("OUT_DIR"), "/adjectives.rs"));

/// List of English noun words
pub const NOUNS: &[&str] = &include!(concat!(env!("OUT_DIR"), "/nouns.rs"));

/// A naming strategy for the `Generator`
#[derive(Debug, PartialEq, Default)]
pub enum Name {
    /// This represents a Title cased naming strategy in the form of `"adjective-noun"`
    Plain,
    /// This represents a Title cased naming strategy in the form of `"adjective-noun-number"`
    Numbered,
    /// This represents a Title cased naming strategy in the form of `"Adjective Noun"`
    TitleCase,
    /// This represents a Camel cased naming strategy in the form of `"adjectiveNoun"`
    CamelCase,
    /// This represents a Class cased naming strategy in the form of `"AdjectiveNoun"`
    ClassCase,
    /// This represents a Kebab cased naming strategy in the form of `"adjective-noun"`
    #[default]
    KebabCase,
    /// This represents a Train cased naming strategy in the form of `"Adjective-Noun"`
    TrainCase,
    /// This represents a Screaming Snake cased naming strategy in the form of `"Adjective_Noun"`
    ScreamingSnakeCase,
    /// This represents a Table cased naming strategy in the form of `"adjective-noun"`
    TableCase,
    /// This represents a Sentence cased naming strategy in the form of `"Adjective noun"`
    SentenceCase,
    /// This represents a Snake cased naming strategy in the form of `"adjective_noun"`
    SnakeCase,
    /// This represents a Pascal cased naming strategy in the form of `"AdjectiveNoun"`
    PascalCase,
}

impl FromStr for Name {
    type Err = ();

    fn from_str(input: &str) -> Result<Name, Self::Err> {
        match input {
            "Plain" => Ok(Name::Plain),
            "Numbered" => Ok(Name::Numbered),
            "TitleCase" => Ok(Name::TitleCase),
            "CamelCase" => Ok(Name::CamelCase),
            "ClassCase" => Ok(Name::ClassCase),
            "KebabCase" => Ok(Name::KebabCase),
            "TrainCase" => Ok(Name::TrainCase),
            "ScreamingSnakeCase" => Ok(Name::ScreamingSnakeCase),
            "TableCase" => Ok(Name::TableCase),
            "SentenceCase" => Ok(Name::SentenceCase),
            "SnakeCase" => Ok(Name::SnakeCase),
            "PascalCase" => Ok(Name::PascalCase),
            _ => Err(()),
        }
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
    numbered: bool,
    rng: ThreadRng,
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
    /// let numbered = false
    ///
    /// let mut generator = Generator::new(adjectives, nouns, naming, numbered);
    ///
    /// assert_eq!("sassy-clocks", generator.next().unwrap());
    /// ```
    pub fn new(
        adjectives: &'a [&'a str],
        nouns: &'a [&'a str],
        naming: Name,
        numbered: bool,
    ) -> Self {
        Generator {
            adjectives,
            nouns,
            naming,
            numbered,
            rng: ThreadRng::default(),
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
    pub fn with_naming(naming: Name) -> Self {
        Generator::new(ADJECTIVES, NOUNS, naming, false)
    }

    /// Construct and returns a default `Generator<'a>` containing a large
    /// collection of adjectives and nouns
    ///
    /// ```
    /// use names::{Generator, Name};
    ///
    /// let mut generator = Generator::with_numbers(Name::Plain);
    ///
    /// println!("My new name is: {}", generator.next().unwrap());
    /// ```
    pub fn with_numbers(naming: Name) -> Self {
        Generator::new(ADJECTIVES, NOUNS, naming, true)
    }
}

impl<'a> Default for Generator<'a> {
    fn default() -> Self {
        Generator::new(ADJECTIVES, NOUNS, Name::default(), false)
    }
}

impl<'a> Iterator for Generator<'a> {
    type Item = String;

    fn next(&mut self) -> Option<String> {
        let adj = self.adjectives.choose(&mut self.rng).unwrap();
        let noun = self.nouns.choose(&mut self.rng).unwrap();

        let generated = if self.numbered {
            format!("{} {} {:04}", adj, noun, rand_num(&mut self.rng))
        } else {
            format!("{} {}", adj, noun)
        };

        Some(match self.naming {
            Name::Plain => generated.to_kebab_case(),
            Name::Numbered => {
                format!("{}-{}-{:04}", adj, noun, rand_num(&mut self.rng)).to_kebab_case()
            }
            Name::TitleCase => generated.to_title_case(),
            Name::CamelCase => generated.to_camel_case(),
            Name::ClassCase => generated.to_class_case(),
            Name::KebabCase => generated.to_kebab_case(),
            Name::TrainCase => generated.to_train_case(),
            Name::ScreamingSnakeCase => generated.to_screaming_snake_case(),
            Name::TableCase => generated.to_table_case(),
            Name::SentenceCase => generated.to_sentence_case(),
            Name::SnakeCase => generated.to_snake_case(),
            Name::PascalCase => generated.to_pascal_case(),
        })
    }
}

fn rand_num(rng: &mut ThreadRng) -> u16 {
    rng.gen_range(1..10000)
}
