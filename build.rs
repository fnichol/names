use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader, BufWriter, Write};
use std::path::Path;

fn main() {
    let out_dir = env::var("OUT_DIR").expect("OUT_DIR environment variable should be set");

    generate(
        Path::new("data").join("adjectives.txt").as_path(),
        Path::new(&out_dir).join("adjectives.rs").as_path(),
    )
    .expect("source file for adjectives should be generated");
    generate(
        Path::new("data").join("nouns.txt").as_path(),
        Path::new(&out_dir).join("nouns.rs").as_path(),
    )
    .expect("source file for nouns should be generated");
}

fn generate(src_path: &Path, dst_path: &Path) -> io::Result<()> {
    let src = File::open(src_path)?;
    let src = BufReader::new(src);
    let dst = File::create(dst_path)?;
    let mut dst = BufWriter::new(dst);

    write!(dst, "[\n")?;
    for word in src.lines() {
        write!(dst, "\"{}\",\n", &word.unwrap())?;
    }
    write!(dst, "]\n")
}
