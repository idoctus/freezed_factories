import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_factories_annotation/freezed_factories_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@freezed
class Person {
  const Person._();

  factory Person({
    required String firstName,
    required String lastName,
    @Default('female') String? gender,
    int? age,
  }) => Person._();

  static PersonFactory get factory => PersonFactory();
}

enum NotAClass { a }

class ClassWithoutFreezed {}

@freezed
class ClassWithoutFactoryGetter {}

@freezed
class ClassWithoutPublicFactory {
  static ClassWithoutPublicFactoryFactory get factory =>
      ClassWithoutPublicFactoryFactory();
}

@freezed
class ClassWithoutNamedParameters {
  const ClassWithoutNamedParameters._();

  factory ClassWithoutNamedParameters(int parameter) =>
      ClassWithoutNamedParameters._();

  static ClassWithoutNamedParametersFactory get factory =>
      ClassWithoutNamedParametersFactory();
}

@ShouldGenerateFile('generate_example_golden.dart', partOfCurrent: true)
@FreezedFactory(Person)
class PersonFactory {}

@ShouldThrow('@FreezedFactory can only be applied on classes.')
@FreezedFactory(NotAClass)
class NotAClassFactory {}

@ShouldThrow(
  '@FreezedFactory can only be applied on classes with @freezed annotation.',
)
@FreezedFactory(ClassWithoutFreezed)
class ClassWithoutFreezedFactory {}

@ShouldThrow(
  '@FreezedFactory needs a factory static getter.',
  todo:
      'Add a factory static getter to the class.\n\nstatic \$ClassWithoutFactoryGetterFactory get factory => \$ClassWithoutFactoryGetterFactory();',
)
@FreezedFactory(ClassWithoutFactoryGetter)
class ClassWithoutFactoryGetterFactory {}

@ShouldThrow(
  '@FreezedFactory can only be applied on classes with a public factory.',
  todo: 'Add a public factory to the class.',
)
@FreezedFactory(ClassWithoutPublicFactory)
class ClassWithoutPublicFactoryFactory {}

@ShouldThrow(
  '@FreezedFactory can only be applied on classes with named parameters.',
)
@FreezedFactory(ClassWithoutNamedParameters)
class ClassWithoutNamedParametersFactory {}
