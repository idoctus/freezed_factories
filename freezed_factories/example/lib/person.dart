import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_factories_annotation/freezed_factories_annotation.dart';

part 'person.factory.dart';
part 'person.freezed.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    @Default('female') String? gender,
    int? age,
  }) = _Person;

  static PersonFactory get factory => PersonFactory();
}

@FreezedFactory(Person)
class PersonFactory with _$PersonFactory {
  @override
  Person get defaults => Person(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        age: faker.randomGenerator.integer(99),
      );

  PersonFactory adult() {
    return state((state) => state(
          age: faker.randomGenerator.integer(99, min: 18),
        ));
  }

  PersonFactory male() {
    return state((state) => state(
          gender: 'male',
        ));
  }
}
