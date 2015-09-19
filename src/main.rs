#[macro_use] extern crate clap;
extern crate names;

use clap::{App, Arg};
use names::Generator;

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

    let amount = value_t!(matches.value_of("AMOUNT"), u32).unwrap_or(1);
    let gen = Generator::default();

    for _ in 0..amount {
        if matches.is_present("number") {
            println!("{}", gen.name_with_number());
        } else {
            println!("{}", gen.name());
        }
    }
}
