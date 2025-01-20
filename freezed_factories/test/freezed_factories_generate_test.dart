import 'dart:async';

import 'package:freezed_factories/src/factory_generator.dart';
import 'package:freezed_factories_annotation/freezed_factories_annotation.dart';
import 'package:source_gen_test/src/build_log_tracking.dart';
import 'package:source_gen_test/src/init_library_reader.dart';
import 'package:source_gen_test/src/test_annotated_classes.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'generate_example.dart',
  );

  initializeBuildLogTracking();
  testAnnotatedElements<FreezedFactory>(
    reader,
    FactoryGenerator(),
  );
}
