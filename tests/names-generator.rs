use names::Generator;
use names::Name;

#[test]
fn test_name_generator() {
    let adjectives = &["imaginary"];
    let nouns = &["roll"];
    let mut generator = Generator::new(adjectives, nouns, Name::default());
    assert_eq!("imaginary-roll", generator.next().unwrap());
}

#[test]
fn test_name_items_and_iterator() {
    let generated = Generator::with_naming(Name::default()).take(10);
    assert_eq!(10, generated.count());
}

#[test]
fn test_random_number() {
    let generated = Generator::with_naming(Name::Numbered).take(10);
    assert_eq!(10, generated.count());
}
