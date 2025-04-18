[![Build Status](https://github.com/idoctus/freezed_factories/workflows/CI/badge.svg)](https://github.com/idoctus/freezed_factories/actions)
[![Pub](https://img.shields.io/pub/v/freezed_factories.svg)](https://pub.dartlang.org/packages/freezed_factories)

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
`@FreezedFactory(FreezedClassName)`, add the mixin, override the `_defaults` getter and import the
part file.

Also you can create methods to generate different states of the object.

```dart
import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_factories_annotation/freezed_factories_annotation.dart';

part 'person.factory.dart';
part 'person.freezed.dart';

@freezed
abstract class Person with _$Person {
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
  Person get _defaults => Person(
    firstName: faker.person.firstName(),
    lastName: faker.person.lastName(),
    age: faker.randomGenerator.integer(99),
  );

  PersonFactory adult() {
    return state((state) => state(
      age: faker.randomGenerator.integer(99, min: 18),
    ));
  }
}
```

In the example above, [faker](https://pub.dev/packages/faker) is used to generate random data.
