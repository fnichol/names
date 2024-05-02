use names::Generator;

fn main() {
    let args = cli::parse();

    let generated = if args.number {
        Generator::with_numbers(args.naming())
    } else {
        Generator::with_naming(args.naming())
    };

    generated
        .take(args.amount)
        .for_each(|name| println!("{}", name));
}

mod cli {
    use clap::Parser;
    use names::Name;
    use std::str::FromStr;

    const AUTHOR: &str = concat!(env!("CARGO_PKG_AUTHORS"), "\n\n");
    const VERSION: &str = env!("CARGO_PKG_VERSION");

    pub(crate) fn parse() -> Args {
        Args::parse()
    }

    /// A random name generator with results like "delirious-pail"
    #[derive(Parser, Debug)]
    #[clap(author = AUTHOR, version = VERSION)]
    pub(crate) struct Args {
        /// Adds a random number to the name(s)
        #[clap(short, long)]
        pub(crate) number: bool,

        /// Use a different naming strategy
        ///  - Plain* [adjective-noun]
        ///  - Numbered [adjective-noun-number]
        ///  - TitleCase [Adjective Noun]
        ///  - CamelCase [adjectiveNoun]
        ///  - ClassCase [AdjectiveNoun]
        ///  - KebabCase [adjective-noun]
        ///  - TrainCase [Adjective-Noun]
        ///  - TableCase [adjective-noun]
        ///  - SnakeCase [adjective_noun]
        ///  - PascalCase [AdjectiveNoun]
        ///  - SentenceCase [Adjective noun]
        ///  - ScreamingSnakeCase [Adjective_Noun]
        ///*
        #[clap(short, long, default_value = "Plain", verbatim_doc_comment)]
        pub(crate) strategy: String,

        /// Number of names to generate
        #[clap(default_value = "1")]
        pub(crate) amount: usize,
    }

    impl Args {
        pub(crate) fn naming(&self) -> Name {
            Name::from_str(&self.strategy).unwrap()
        }
    }
}
