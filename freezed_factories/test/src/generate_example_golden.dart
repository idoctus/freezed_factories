part of 'generate_example.dart';

mixin _$PersonFactory {
  final List<Person Function(Person)> _states = [];

  Person get _defaults;

  Person get _createFromStates {
    var object = _defaults;

    for (final modifier in _states) {
      object = modifier(object);
    }

    return object;
  }

  PersonFactory state(
    Person Function(Person) Function($PersonFactoryState) state,
  ) {
    _states.add(state(_state));

    return this as PersonFactory;
  }

  $PersonFactoryState get _state => _$PersonFactoryStateImpl();

  $PersonFactoryCreate get create =>
      _$PersonFactoryCreateImpl(() => _createFromStates);

  $PersonFactoryCreateMany get createMany =>
      _$PersonFactoryCreateManyImpl(() => _createFromStates);
}

abstract class $PersonFactoryState {
  Person Function(Person) call({
    String firstName,
    String lastName,
    String? gender,
    int? age,
  });
}

abstract class $PersonFactoryCreate {
  Person call({String firstName, String lastName, String? gender, int? age});
}

abstract class $PersonFactoryCreateMany {
  List<_Person> call(
    int count, {
    String firstName,
    String lastName,
    String? gender,
    int? age,
  });
}

class _$PersonFactoryStateImpl implements $PersonFactoryState {
  _$PersonFactoryStateImpl();

  @override
  Person Function(Person) call({
    Object? firstName = null,
    Object? lastName = null,
    Object? gender = freezed,
    Object? age = freezed,
  }) =>
      (defaults) => (defaults.copyWith as __$PersonCopyWithImpl<_Person>).call(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        age: age,
      );
}

class _$PersonFactoryCreateImpl implements $PersonFactoryCreate {
  _$PersonFactoryCreateImpl(this._default);

  final Person Function() _default;

  @override
  Person call({
    Object? firstName = null,
    Object? lastName = null,
    Object? gender = freezed,
    Object? age = freezed,
  }) => (_default().copyWith as __$PersonCopyWithImpl<_Person>).call(
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    age: age,
  );
}

class _$PersonFactoryCreateManyImpl implements $PersonFactoryCreateMany {
  _$PersonFactoryCreateManyImpl(this._default);

  final Person Function() _default;

  @override
  List<_Person> call(
    int count, {
    Object? firstName = null,
    Object? lastName = null,
    Object? gender = freezed,
    Object? age = freezed,
  }) => List.generate(
    count,
    (index) => (_default().copyWith as __$PersonCopyWithImpl<_Person>).call(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      age: age,
    ),
  );
}
