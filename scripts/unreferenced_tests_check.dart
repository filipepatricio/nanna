// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

final unitTestsDir = Directory('test/unit/tests');
final visualTestsDir = Directory('test/visual/tests');

final unitTestsWrapper = File('test/unit/wrapper_test.dart');
final visualTestsWrapper = File('test/visual/wrapper_test.dart');
final visualTestsWrapperDark = File('test/visual/wrapper_dark_test.dart');

Future<void> main(List<String> args) async {
  try {
    final unreferencedUnitTests = <String>{};
    final unreferencedVisualTests = <String>{};
    final unreferencedVisualTestsDark = <String>{};

    final unitTestWrapperContent = unitTestsWrapper.readAsStringSync();
    final visualTestsWrapperContent = visualTestsWrapper.readAsStringSync();
    final visualTestsWrapperDarkContent = visualTestsWrapperDark.readAsStringSync();

    print('> Checking unit test files ...');
    for (final file in unitTestsDir.testFiles) {
      if (!unitTestWrapperContent.contains(file.name)) {
        unreferencedUnitTests.add(file.path);
      }
    }

    print('> Checking visual test files ...');
    for (final file in visualTestsDir.testFiles) {
      if (!visualTestsWrapperContent.contains(file.name)) {
        unreferencedVisualTests.add(file.path);
      }

      if (!visualTestsWrapperDarkContent.contains(file.name)) {
        unreferencedVisualTestsDark.add(file.path);
      }
    }

    if (unreferencedUnitTests.isEmpty && unreferencedVisualTests.isEmpty && unreferencedVisualTestsDark.isEmpty) {
      print('✓ Done: All tests are correctly referenced in their corresponding wrappers');
      exit(0);
    }

    if (unreferencedUnitTests.isNotEmpty) {
      stderr.writeln('Error: Unreferenced unit tests :\n\n${unreferencedUnitTests.join('\n')}');
    }
    if (unreferencedVisualTests.isNotEmpty) {
      stderr.writeln('Error: Unreferenced visual tests in light wrapper :\n\n${unreferencedVisualTests.join('\n')}');
    }
    if (unreferencedVisualTestsDark.isNotEmpty) {
      stderr.writeln('Error: Unreferenced visual tests in dark wrapper :\n\n${unreferencedVisualTestsDark.join('\n')}');
    }
    exit(2);
  } catch (error, stack) {
    stderr
      ..writeln(error)
      ..writeln(stack);
    exit(3);
  }
}

extension on FileSystemEntity {
  String get name => path.substring(path.lastIndexOf('/') + 1);
}

extension on Directory {
  Iterable<File> get testFiles => listSync(recursive: true)
      .where(
        (x) => x is File && x.path.endsWith('_test.dart'),
      )
      .cast<File>();
}
