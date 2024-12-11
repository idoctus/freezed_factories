library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/factory_generator.dart';

Builder factoryBuilder(BuilderOptions options) => LibraryBuilder(
      FactoryGenerator(),
      generatedExtension: '.factory.dart',
      header: '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
    ''',
    );
