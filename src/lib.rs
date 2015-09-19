extern crate rand;

use rand::Rng;

mod adjectives;
mod nouns;

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

pub struct Generator<'a> {
    adjectives: Dictionary<'a>,
    nouns: Dictionary<'a>,
}

impl<'a> Generator<'a> {
    pub fn new(adjectives: Dictionary<'a>, nouns: Dictionary<'a>) -> Generator<'a> {
        Generator { adjectives: adjectives, nouns: nouns }
    }

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
