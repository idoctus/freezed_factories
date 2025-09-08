import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/build.dart';
import 'package:freezed_factories_annotation/freezed_factories_annotation.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for the `@FreezedFactory` annotation.
///
/// It is the main piece of the package.
class FactoryGenerator extends GeneratorForAnnotation<FreezedFactory> {
  @override
  String generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final typeElement = annotation.read('type').typeValue.element3;

    if (typeElement == null) {
      throw InvalidGenerationSource(
        'Invalid type provided to @FreezedFactory annotation.',
        element: element,
      );
    }

    checkIsClass(typeElement);
    typeElement as ClassElement2;

    checkFreezed(typeElement);

    checkFactoryGetter(typeElement);

    final constructor = typeElement.constructors2.firstWhere(
      (element) => !element.isPrivate && element.isFactory,
      orElse: () => throw InvalidGenerationSource(
        '@FreezedFactory can only be applied on classes with a public factory.',
        todo: 'Add a public factory to the class.',
        element: element,
      ),
    );

    final parameters = constructor.formalParameters;
    checkParameters(parameters, typeElement);

    return _generateFactory(typeElement.displayName, parameters);
  }

  void checkIsClass(Element2 element) {
    if (element is! ClassElement2) {
      throw InvalidGenerationSource(
        '@FreezedFactory can only be applied on classes.',
        element: element,
      );
    }
  }

  void checkFreezed(ClassElement2 element) {
    if (!element.metadata2.annotations.any((element) =>
        element.computeConstantValue()?.type?.element3?.displayName ==
        'Freezed')) {
      throw InvalidGenerationSource(
        '@FreezedFactory can only be applied on classes with @freezed annotation.',
        element: element,
      );
    }
  }

  void checkFactoryGetter(ClassElement2 element) {
    final factoryGetter = element.getGetter2('factory');

    if (factoryGetter == null || !factoryGetter.isStatic) {
      throw InvalidGenerationSource(
        '@FreezedFactory needs a factory static getter.',
        todo:
            'Add a factory static getter to the class.\n\nstatic \$${element.displayName}Factory get factory => \$${element.displayName}Factory();',
        element: element,
      );
    }
  }

  void checkParameters(
      List<FormalParameterElement> parameters, ClassElement2 element) {
    for (final parameter in parameters) {
      if (!parameter.isNamed) {
        throw InvalidGenerationSource(
          '@FreezedFactory can only be applied on classes with named parameters.',
          element: parameter,
        );
      }
    }
  }

  String _generateFactory(
      String className, List<FormalParameterElement> parameters) {
    var typedParameters = '';
    var dynamicParameters = '';
    var callParameters = '';

    for (final parameter in parameters) {
      final type = parameter.type;
      final name = parameter.displayName;
      final isNullable = type.nullabilitySuffix == NullabilitySuffix.question;

      typedParameters += '$type $name,\n';
      dynamicParameters +=
          'Object? $name = ${isNullable ? 'freezed' : 'null'},\n';
      callParameters += '$name: $name,\n';
    }

    return '''
mixin _\$${className}Factory { 
  final List<$className Function($className)> _states = [];

  $className get _defaults;
  
  $className get _createFromStates {
    var object = _defaults;

    for (final modifier in _states) {
      object = modifier(object);
    }

    return object;
  }
  
  ${className}Factory state(
      $className Function($className) Function(\$${className}FactoryState) state) {
    _states.add(state(_state));

    return this as ${className}Factory;
  }
  
  \$${className}FactoryState get _state => _\$${className}FactoryStateImpl();

  \$${className}FactoryCreate get create =>
      _\$${className}FactoryCreateImpl(() => _createFromStates);

  \$${className}FactoryCreateMany get createMany =>
      _\$${className}FactoryCreateManyImpl(() => _createFromStates);
}

abstract class \$${className}FactoryState {
  $className Function($className) call({
    $typedParameters
  });
}

abstract class \$${className}FactoryCreate {
  $className call({
    $typedParameters
  });
}

abstract class \$${className}FactoryCreateMany {
  List<_$className> call(int count, {
    $typedParameters
  });
}

class _\$${className}FactoryStateImpl
    implements \$${className}FactoryState {
  _\$${className}FactoryStateImpl();

  @override
  $className Function($className) call({
    $dynamicParameters
  }) =>
      (defaults) =>
          (defaults.copyWith as __\$${className}CopyWithImpl<_$className>)
              .call(
            $callParameters
          );
}

class _\$${className}FactoryCreateImpl
    implements \$${className}FactoryCreate {
  _\$${className}FactoryCreateImpl(this._default);

  final $className Function() _default;

  @override
  $className call({
    $dynamicParameters
  }) =>
      (_default().copyWith as __\$${className}CopyWithImpl<_$className>)
            .call(
          $callParameters
        );
}

class _\$${className}FactoryCreateManyImpl
    implements \$${className}FactoryCreateMany {
  _\$${className}FactoryCreateManyImpl(this._default);

  final $className Function() _default;

  @override
  List<_$className> call(int count, {
    $dynamicParameters
  }) =>
      List.generate(
        count,
        (index) => (_default().copyWith as __\$${className}CopyWithImpl<_$className>)
            .call(
          $callParameters
        ),
      );
}
''';
  }
}
