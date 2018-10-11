use std::env;
use std::fs::File;
use std::io::prelude::*;
use std::io::{BufReader, BufWriter};
use std::path::Path;

fn main() {
    generate(
        Path::new("data").join("adjectives.txt").as_path(),
        Path::new(&env::var("OUT_DIR").unwrap())
            .join("adjectives.rs")
            .as_path(),
    );
    generate(
        Path::new("data").join("nouns.txt").as_path(),
        Path::new(&env::var("OUT_DIR").unwrap())
            .join("nouns.rs")
            .as_path(),
    );
}

fn generate(src_path: &Path, dst_path: &Path) {
    let src = File::open(src_path).unwrap();
    let src = BufReader::new(src);
    let dst = File::create(dst_path).unwrap();
    let mut dst = BufWriter::new(dst);
    write!(dst, "[\n").unwrap();
    for word in src.lines() {
        write!(dst, "\"{}\",\n", &word.unwrap()).unwrap();
    }
    write!(dst, "];\n").unwrap();
}
