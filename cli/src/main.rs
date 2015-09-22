#[macro_use] extern crate clap;
extern crate names;

use clap::{App, Arg};
use names::{Generator, Name};

fn main() {
    let matches = App::new("names")
        .version(&crate_version!()[..])
        .author("Fletcher Nichol <fnichol@nichol.ca>")
        .about("Random name generator")
        .arg(Arg::with_name("AMOUNT")
             .help("Number of names to generate (default: 1)")
             .index(1)
        )
        .arg(Arg::with_name("number")
             .short("n")
             .long("number")
             .help("Adds a random number to the name(s)")
        )
        .get_matches();

    let amount = value_t!(matches.value_of("AMOUNT"), usize).unwrap_or(1);
    let naming = if matches.is_present("number") {
        Name::Numbered
    } else {
        Name::Plain
    };

    let mut generator = Generator::default(naming);
    for _ in 0..amount {
        println!("{}", generator.next().unwrap());
    }
}
