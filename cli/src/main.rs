#[macro_use]
extern crate clap;
extern crate names;

use clap::{AppSettings, Arg};

use names::{Generator, Name};

fn main() {
    let (naming, amount) = parse_cli_args();
    let mut generator = Generator::with_naming(naming);
    for _ in 0..amount {
        println!("{}", generator.next().unwrap());
    }
}

fn parse_cli_args() -> (Name, usize) {
    const FLAG_NUMBER: &str = "number";
    const ARG_AMOUNT: &str = "amount";

    let app = app_from_crate!()
        .name("names")
        .setting(AppSettings::ColoredHelp)
        .arg(
            Arg::with_name(FLAG_NUMBER)
                .short("n")
                .long(FLAG_NUMBER)
                .help("Adds a random number to the name(s)"),
        )
        .arg(
            Arg::with_name(ARG_AMOUNT)
                .help("Number of names to generate")
                .default_value("1"),
        );

    let matches = app.get_matches();
    let amount = value_t_or_exit!(matches.value_of(ARG_AMOUNT), usize);
    let naming: Name = if matches.is_present(FLAG_NUMBER) {
        Name::Numbered
    } else {
        Default::default()
    };

    (naming, amount)
}
