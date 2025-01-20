# freezed_factories

Create test factories for your Freezed classes easily.

## Install

To use `freezed_factories` you will need the generator and the annotation package.

For a Flutter project:

```console
flutter pub add freezed_factories_annotation
flutter pub add dev:freezed_factories
```

For a Dart project:

```console
dart pub add freezed_factories_annotation
dart pub add dev:freezed_factories
```

## How to use

To generate a factory for class, create a class, annotate it with
`@FreezedFactory(FreezedClassName)`, add the mixin, override the `defaults` getter and import the
part file.

```dart
part 'person.factory.dart';

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
