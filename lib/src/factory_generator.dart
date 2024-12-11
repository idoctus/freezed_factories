import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

class FactoryGenerator extends GeneratorForAnnotation<FreezedFactory> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    checkIsClass(element);
    element as ClassElement;

    checkFreezed(element);
    checkFactoryDefaultGetter(element);
    checkFactoryGetter(element);

    final constructor = element.constructors.firstWhere(
      (element) => !element.isPrivate && element.isFactory,
      orElse: () => throw InvalidGenerationSourceError(
        '@freezedFactory can only be applied on classes with a public factory.',
        element: element,
      ),
    );

    final parameters = constructor.parameters;
    checkParameters(parameters, element);

    return _generateFactory(element.name, parameters);
  }

  void checkIsClass(Element element) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@freezedFactory can only be applied on classes.',
        element: element,
      );
    }
  }

  void checkFreezed(ClassElement element) {
    if (!element.metadata.any((element) =>
        element.computeConstantValue()?.type?.element?.name == 'Freezed')) {
      throw InvalidGenerationSourceError(
        '@freezedFactory can only be applied on classes with @freezed annotation.',
        element: element,
      );
    }
  }

  void checkFactoryDefaultGetter(ClassElement element) {
    final factoryDefaultGetter = element.getGetter('factoryDefault');

    if (factoryDefaultGetter == null || !factoryDefaultGetter.isStatic) {
      throw InvalidGenerationSourceError(
        '@freezedFactory needs a factoryDefault static getter.',
        element: element,
      );
    }

    if (factoryDefaultGetter.returnType.element != element) {
      throw InvalidGenerationSourceError(
        'factoryDefault getter should return ${element.name}.',
        element: factoryDefaultGetter,
      );
    }
  }

  void checkFactoryGetter(ClassElement element) {
    final factoryGetter = element.getGetter('factory');

    if (factoryGetter == null || !factoryGetter.isStatic) {
      throw InvalidGenerationSourceError(
        '@freezedFactory needs a factory static getter. Please add this:\n\nstatic \$${element.name}Factory get factory => \$${element.name}Factory();\n',
        element: element,
      );
    }
  }

  void checkParameters(
      List<ParameterElement> parameters, ClassElement element) {
    for (final parameter in parameters) {
      if (!parameter.isNamed) {
        throw InvalidGenerationSourceError(
          '@freezedFactory can only be applied on classes with named parameters.',
          element: parameter,
        );
      }
    }
  }

  String _generateFactory(String className, List<ParameterElement> parameters) {
    var typedParameters = '';
    var dynamicParameters = '';
    var callParameters = '';

    for (final parameter in parameters) {
      typedParameters += '    ${parameter.type} ${parameter.name},\n';
      dynamicParameters +=
          '    Object? ${parameter.name}${parameter.isRequired ? '' : ' = freezed'},\n';
      callParameters += '        ${parameter.name}: ${parameter.name},\n';
    }

    return '''
part of 'person.dart';

class \$${className}Factory { 
  \$${className}FactoryCreate get create =>
      _\$${className}FactoryCreateImpl(${className}.factoryDefault);

  \$${className}FactoryCreateMany get createMany =>
      _\$${className}FactoryCreateManyImpl(${className}.factoryDefault);
}

abstract class \$${className}FactoryCreate {
  ${className} call({
    ${typedParameters}
  });
}

class _\$${className}FactoryCreateImpl
    implements \$${className}FactoryCreate {
  _\$${className}FactoryCreateImpl(this._default);

  final ${className} _default;

  @override
  ${className} call({
   ${dynamicParameters}
  }) =>
      (_default.copyWith as _\$${className}CopyWithImpl<${className},
              ${className}>)
          .call(
        ${callParameters}
      );
}

abstract class \$${className}FactoryCreateMany {
  List<${className}> call(
    int count, {
    ${typedParameters}
  });
}

class _\$${className}FactoryCreateManyImpl
    implements \$${className}FactoryCreateMany {
  _\$${className}FactoryCreateManyImpl(this._default);

  final ${className} _default;

  @override
  List<${className}> call(
    int count, {
    ${dynamicParameters}
  }) =>
      List.generate(
        count,
        (index) => (_default.copyWith as _\$${className}CopyWithImpl<
                ${className}, ${className}>)
            .call(
          ${callParameters}
        ),
      );
}
''';
  }
}
