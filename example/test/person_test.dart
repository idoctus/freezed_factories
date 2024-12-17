import 'package:example/person.dart';
import 'package:test/test.dart';

void main() {
  group('single', () {
    test('defaults', () {
      final person = Person.factory.create();

      expect(person.firstName, isNotNull);
      expect(person.lastName, isNotNull);
      expect(person.gender, 'female');
      expect(person.age, isNotNull);
    });

    test('specific', () {
      final person = Person.factory.create(
        firstName: 'John',
        lastName: 'Doe',
        gender: 'male',
        age: 42,
      );

      expect(person.firstName, 'John');
      expect(person.lastName, 'Doe');
      expect(person.gender, 'male');
      expect(person.age, 42);
    });

    test('null optional', () {
      final person = Person.factory.create(
        age: null,
        gender: null,
      );

      expect(person.age, isNull);
      expect(person.gender, isNull);
    });

    test('state', () {
      final factory = Person.factory.adult();
      final person = factory.create();
      final person2 = factory.create();

      expect(person.age, greaterThanOrEqualTo(18));
      expect(person2.age, greaterThanOrEqualTo(18));
    });

    test('multiple states', () {
      final person = Person.factory.adult().male().create();
      final person2 = Person.factory.male().adult().create();

      expect(person.age, greaterThanOrEqualTo(18));
      expect(person.gender, 'male');

      expect(person2.age, greaterThanOrEqualTo(18));
      expect(person2.gender, 'male');
    });
  });

  group('multiple', () {
    test('defaults', () {
      final person = Person.factory.createMany(2);

      expect(person, hasLength(2));

      expect(person[0].firstName, isNotNull);
      expect(person[0].lastName, isNotNull);
      expect(person[0].gender, 'female');
      expect(person[0].age, isNotNull);

      expect(person[1].firstName, isNotNull);
      expect(person[1].lastName, isNotNull);
      expect(person[1].gender, 'female');
      expect(person[1].age, isNotNull);

      expect(person[0].firstName, isNot(person[1].firstName));
      expect(person[0].lastName, isNot(person[1].lastName));
      expect(person[0].age, isNot(person[1].age));
    });

    test('specific', () {
      final person = Person.factory.createMany(
        2,
        firstName: 'John',
        lastName: 'Doe',
        gender: 'male',
        age: 42,
      );

      expect(person[0].firstName, 'John');
      expect(person[0].lastName, 'Doe');
      expect(person[0].gender, 'male');
      expect(person[0].age, 42);

      expect(person[1].firstName, 'John');
      expect(person[1].lastName, 'Doe');
      expect(person[1].gender, 'male');
      expect(person[1].age, 42);
    });

    test('null optional', () {
      final person = Person.factory.createMany(
        2,
        gender: null,
        age: null,
      );

      expect(person[0].age, isNull);
      expect(person[0].gender, isNull);

      expect(person[1].age, isNull);
      expect(person[1].gender, isNull);
    });
  });
}
