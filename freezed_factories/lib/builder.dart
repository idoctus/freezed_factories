library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/factory_generator.dart';

/// A `Builder` for `build_runner`.
Builder factoryBuilder(BuilderOptions options) => PartBuilder(
      [FactoryGenerator()],
      '.factory.dart',
      header: '''
// coverage:ignore-file
// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND
    ''',
    );
