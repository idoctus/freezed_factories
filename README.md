# freezed_factories

Create tests factories for your Freezed classes easily using code generation.

## Example

To generate a factory for class, create a class, annotate it with
`@FreezedFactory(FreezedClassName)`, add the mixin and override the `defaults` getter.

```dart
@freezed
class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    int? age,
  }) = _Person;

  static PersonFactory get factory => PersonFactory();
}

@FreezedFactory(Person)
class PersonFactory with _$PersonFactory {
  @override
  Person get defaults =>
      Person(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        age: faker.randomGenerator.integer(99),
      );
}
```

In the example above, [faker](https://pub.dev/packages/faker) is used to generate random data.
