#[macro_use]
extern crate clap;
extern crate names;

use names::{Generator, Name};

fn main() {
    let (naming, amount) = {
        let app = clap_app!(names =>
                (version: &crate_version!()[..])
                (author: "\nAuthor: Fletcher Nichol <fnichol@nichol.ca>\n")
                (about: "A random name generator with results like `delirious-pail'.")
                (@setting ColoredHelp)
                (@arg amount: "Number of names to generate (default: 1)")
                (@arg number: -n --number "Adds a random number to the name(s)")
        );
        let matches = app.get_matches();
        let amount = value_t!(matches.value_of("amount"), usize).unwrap_or(1);
        let naming: Name = if matches.is_present("number") {
            Name::Numbered
        } else {
            Default::default()
        };
        (naming, amount)
    };

    let mut generator = Generator::with_naming(naming);
    for _ in 0..amount {
        println!("{}", generator.next().unwrap());
    }
}
