import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_factories/annotations.dart';
import 'package:source_gen_test/annotations.dart';

part 'generate_example.freezed.dart';

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

@ShouldGenerateFile(
  'generate_example_golden.dart',
  partOfCurrent: true,
)
@FreezedFactory(Person)
class PersonFactory {}
