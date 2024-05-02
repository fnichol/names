#[cfg(test)]
mod tests {
    use names::{Generator, Name};
    use regex::Regex;

    #[test]
    fn plain_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::Plain, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)-(?P<noun>[a-z]+)").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn plain_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::Numbered, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)-(?P<noun>[a-z]+)-?(?P<number>\d+)?").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn title_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::TitleCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)\s(?P<noun>[A-Z]{1}[a-z]+)").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn titled_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::TitleCase, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(
            r"^(?P<adjective>[A-Z]{1}[a-z]+)\s(?P<noun>[A-Z]{1}[a-z]+)\s?(?P<number>\d+)?",
        )
        .unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn camel_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::CamelCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)(?P<noun>[A-Z]{1}[a-z]+)").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn camel_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::CamelCase, true);

        let generated = generator.next().unwrap();
        let re =
            Regex::new(r"^(?P<adjective>[a-z]+)(?P<noun>[A-Z]{1}[a-z]+)(?P<number>\d+)?").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn class_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::ClassCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)(?P<noun>[A-Z]{1}[a-z]+)").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn class_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::ClassCase, true);

        let generated = generator.next().unwrap();
        let re =
            Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)(?P<noun>[A-Z]{1}[a-z]+)(?P<number>\d+)?")
                .unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn kebab_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::KebabCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)-(?P<noun>[a-z]+)").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn kebab_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::KebabCase, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)-(?P<noun>[a-z]+)-?(?P<number>\d+)?").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn train_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::TrainCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)-(?P<noun>[A-Z]{1}[a-z]+)").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("True-Truth", generator.next().unwrap());
    }

    #[test]
    fn train_numbred_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::TrainCase, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(
            r"^(?P<adjective>[A-Z]{1}[a-z]+)-(?P<noun>[A-Z]{1}[a-z]+)-?(?P<number>\d+)?",
        )
        .unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("True-Truth", generator.next().unwrap());
    }

    #[test]
    fn screaming_snake_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::ScreamingSnakeCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]+)_(?P<noun>[A-Z]+)").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("TRUE_TRUTH", generator.next().unwrap());
    }

    #[test]
    fn screaming_snake_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::ScreamingSnakeCase, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]+)_(?P<noun>[A-Z]+)_?(?P<number>\d+)?").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("TRUE_TRUTH", generator.next().unwrap());
    }

    #[test]
    fn table_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::TableCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)_(?P<noun>[a-z]+)").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("true_truths", generator.next().unwrap());
    }

    #[test]
    fn table_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::TableCase, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)_(?P<noun>[a-z]+)_?(?P<number>\d+)?").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("true_truths", generator.next().unwrap());
    }

    #[test]
    fn sentence_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::SentenceCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)\s(?P<noun>[a-z]+)").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("True truth", generator.next().unwrap());
    }

    #[test]
    fn sentence_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::SentenceCase, true);

        let generated = generator.next().unwrap();
        println!("{}", &generated);
        let re = Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)\s(?P<noun>[a-z]+)(?P<number>\d+)?")
            .unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn snake_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::SnakeCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)_(?P<noun>[a-z]+)").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("true_truth", generator.next().unwrap());
    }

    #[test]
    fn snake_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::SnakeCase, true);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[a-z]+)_(?P<noun>[a-z]+)_?(?P<number>\d+)?").unwrap();

        assert!(re.is_match(&generated));

        // assert_eq!("true_truth", generator.next().unwrap());
    }

    #[test]
    fn pascal_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::PascalCase, false);

        let generated = generator.next().unwrap();
        let re = Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)(?P<noun>[A-Z]{1}[a-z]+)").unwrap();

        assert!(re.is_match(&generated));
    }

    #[test]
    fn pascal_numbered_case() {
        let mut generator = Generator::new(&["true"], &["truth"], Name::PascalCase, true);

        let generated = generator.next().unwrap();
        let re =
            Regex::new(r"^(?P<adjective>[A-Z]{1}[a-z]+)(?P<noun>[A-Z]{1}[a-z]+)(?P<number>\d+)")
                .unwrap();

        assert!(re.is_match(&generated));
    }
}
