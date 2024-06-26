// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';

final goldensDir = Directory('test/visual/goldens');
final failuresDir = Directory('test/visual/failures');
final reportDir = Directory('test/visual/ui_changes');
final cacheRoot = Directory('${Directory.systemTemp.path}/cached_goldens');

Future<void> main(List<String> args) async {
  try {
    await printAndExec('git', ['config', 'user.name', '"Scripts"']);
    await getBaselineGoldens();
    print('> Running golden image tests ...');
    final flutterTestResult = await Process.run(
      'flutter',
      [
        'test',
        'test/visual/wrapper_test.dart',
        'test/visual/wrapper_dark_test.dart',
        '--reporter',
        'json',
      ],
    );
    if (flutterTestResult.exitCode == 0) {
      print('✓ Done: No visual changes');
    } else {
      var numVisualChanges = 0;
      var numNewGoldens = 0;
      final unexpectedTestErrors = <String>[];
      final testFilesWhichProduceNewGoldens = <String>{};
      if (reportDir.existsSync()) {
        await reportDir.delete(recursive: true);
      }
      await reportDir.create();
      for (final failedTest in parseFlutterTestOutput((flutterTestResult.stdout as String).trim())) {
        if (RegExp(r'Pixel\stest\sfailed,\s[0-9.]+%\sdiff\sdetected').hasMatch(failedTest.testOutput)) {
          ++numVisualChanges;
        } else if (
            // failedTest.testOutput.contains('Could not be compared against non-existent file')
            RegExp(r'Could\snot\sbe\scompared\sagainst\snon-existent').hasMatch(failedTest.testOutput) ||
                RegExp(r'Pixel\stest\sfailed,\simage\ssizes\sdo\snot\smatch\.').hasMatch(failedTest.testOutput)) {
          testFilesWhichProduceNewGoldens.add('test/visual/${failedTest.testFileName}');
        } else {
          unexpectedTestErrors.add('${failedTest.testFileName}:\n${failedTest.testOutput}');
        }
      }
      if (numVisualChanges > 0) {
        print('> Creating ui changes report ...');
        await createVisualChangesReport();
      }
      if (unexpectedTestErrors.isNotEmpty) {
        stderr.writeln('Error: unexpected test failures:\n${unexpectedTestErrors.join('\n')}');
        exit(2);
      }
      if (testFilesWhichProduceNewGoldens.isNotEmpty) {
        print('> Creating new goldens ...');
        final knownGoldens = [...goldensDir.listSync().where((x) => x is File && x.path.endsWith('.png')).cast<File>()];
        final knownGoldensNames = knownGoldens.map((it) => it.name);
        await runGuarded(
          before: () async {
            await printAndExec('rm', ['-rf', 'test/visual/goldens.backup']);
            await printAndExec('mv', ['test/visual/goldens', 'test/visual/goldens.backup']);
          },
          after: () async {
            await printAndExec('rm', ['-rf', 'test/visual/goldens']);
            await printAndExec('mv', ['test/visual/goldens.backup', 'test/visual/goldens']);
          },
          body: () async {
            await printAndExec('flutter', ['test', '--update-goldens', ...testFilesWhichProduceNewGoldens]);
            if (numVisualChanges == 0) {
              if (reportDir.existsSync()) {
                await reportDir.delete(recursive: true);
              }
              await reportDir.create();
            }
            for (final goldenFile in goldensDir.listSync().where((x) => x is File && x.path.endsWith('.png'))) {
              final fileName = (goldenFile as File).name;
              if (!knownGoldensNames.contains(fileName)) {
                print('>> Found new golden $fileName...');
                ++numNewGoldens;
                await exec('mv', ['test/visual/goldens/$fileName', 'test/visual/ui_changes/__NEW__$fileName']);
              } else {
                final existingGolden = knownGoldens.firstWhere((file) => file.name == fileName);
                if (existingGolden.lengthSync() != goldenFile.lengthSync()) {
                  print('>>> $fileName has changed size...');
                  ++numNewGoldens;
                  await exec('mv', ['test/visual/goldens/$fileName', 'test/visual/ui_changes/__NEW_SIZE__$fileName']);
                }
              }
            }
          },
        );
      }
      if (numVisualChanges == 0 && numNewGoldens == 0) {
        print('✓ Done: No visual changes, no new goldens');
        exit(0);
      }
      print(
        '✓ Done: Found $numVisualChanges visual change(s) and $numNewGoldens new (or changed in size) golden(s), saved in: ${reportDir.absolute.path}',
      );
      exit(1);
    }
  } catch (error, stack) {
    stderr
      ..writeln(error)
      ..writeln(stack);
    exit(3);
  }
}

Future<void> createVisualChangesReport() async {
  if (!failuresDir.existsSync()) {
    stderr.writeln('Error: ${failuresDir.path} does not exist');
    exit(2);
  }
  final testImages = failuresDir.listSync().where((x) => x is File && x.path.endsWith('_testImage.png'));
  if (testImages.isEmpty) {
    stderr.writeln('Error: ${failuresDir.path} does not contain any failure images');
    exit(2);
  }
  if (reportDir.existsSync()) {
    await reportDir.delete(recursive: true);
  }
  await reportDir.create();
  for (final testImage in testImages) {
    final masterImage = File(testImage.path.replaceFirst('_testImage.png', '_masterImage.png'));
    final isolatedDiff = File(testImage.path.replaceFirst('_testImage.png', '_isolatedDiff.png'));
    final changesImageName = testImage.name.replaceFirst('_testImage.png', '.png');
    await exec(
      'convert',
      [
        masterImage.name,
        isolatedDiff.name,
        testImage.name,
        '+append',
        '../ui_changes/$changesImageName',
      ],
      workingDirectory: failuresDir.path,
    );
    print('  $changesImageName');
  }
}

class FailedTest {
  FailedTest(this.testFileName, this.testOutput);

  final String testFileName;
  final String testOutput;
}

Iterable<FailedTest> parseFlutterTestOutput(String flutterTestOutput) sync* {
  try {
    final tests = <int, Map<String, dynamic>>{};
    final testOutput = <int, StringBuffer>{};
    for (final line in const LineSplitter().convert(flutterTestOutput).map((it) => it.trim())) {
      if (line.isEmpty) {
        continue;
      }
      try {
        final map = jsonDecode(line) as Map<String, dynamic>;
        final test = map['test'] as Map<String, dynamic>?;
        if (test != null) {
          final id = test['id'] as int;
          tests[id] = test;
        } else {
          final testId = map['testID'] as int?;
          if (testId != null) {
            final type = map['type'] as String;
            if (type == 'error') {
              final error = map['error'] as String;
              var sb = testOutput[testId];
              if (sb == null) {
                sb = StringBuffer();
                testOutput[testId] = sb;
              }
              sb.writeln(error);
            } else if (type == 'print') {
              final message = map['message'] as String;
              var sb = testOutput[testId];
              if (sb == null) {
                sb = StringBuffer();
                testOutput[testId] = sb;
              }
              sb.writeln(message);
            } else if (type == 'testDone') {
              final result = map['result'] as String;
              if (result == 'error') {
                final test = tests[testId]!;
                final String testFileName;
                final rootUrl = test['root_url'] as String?;
                if (rootUrl != null) {
                  testFileName = rootUrl.substring(rootUrl.lastIndexOf('/') + 1);
                } else {
                  final testName = test['name'] as String;
                  testFileName = RegExp(r'^loading .*/test/visual/([^/]+\.dart)$').firstMatch(testName)!.group(1)!;
                }
                yield FailedTest(testFileName, testOutput[testId]!.toString());
              }
              tests.remove(testId);
              testOutput.remove(testId);
            }
          }
        }
      } catch (_) {
        stdout.writeln('Failed to process: $line');
        rethrow;
      }
    }
  } catch (_) {
    File('${reportDir.path}/ui_changes_report_output.json').writeAsStringSync(flutterTestOutput);
    rethrow;
  }
}

Future<void> getBaselineGoldens() async {
  final sha1 = await exec('git', ['merge-base', 'origin/develop', 'HEAD']);
  final cacheDir = Directory('${cacheRoot.path}/$sha1');

  if (cacheDir.existsSync()) {
    print('> Restoring cached goldens from ${cacheDir.path} ...');
    if (goldensDir.existsSync()) {
      goldensDir.deleteSync(recursive: true);
    }
    goldensDir.createSync(recursive: true);
    await exec('cp', ['-a', '${cacheDir.path}/.', goldensDir.path]);
  } else {
    print('> Creating goldens from baseline...');
    final gitStatus = await exec('git', ['status', '-s']);
    var head = await exec('git', ['rev-parse', 'HEAD']);
    await runGuarded(
      before: () async {
        if (gitStatus.isNotEmpty) {
          print('> > Creating temporary WIP commit containing work directory changes ...');
          await printAndExec('git', ['add', '-A']);
          await printAndExec('git', ['commit', '--no-verify', '-m', 'WIP']);
          head = await exec('git', ['rev-parse', 'HEAD']);
        }
      },
      body: () async {
        await runGuarded(
          before: () async {
            if (head != sha1) {
              print('> > Resetting work directory to baseline ...');
              await printAndExec('git', ['reset', '--hard', sha1]);
            }
          },
          body: () async {
            print('> > Rebuilding baseline ...');
            await printAndExec('make', ['get']);
            await printAndExec('make', ['localization']);
            await printAndExec('make', ['build_runner']);
            print('> > Updating goldens ...');
            await printAndExec('make', ['update_goldens']);
            print('> > Caching goldens ...');
            cacheDir.createSync(recursive: true);
            await exec('cp', ['-a', '${goldensDir.path}/.', cacheDir.path]);
          },
          after: () async {
            if (head != sha1) {
              print('> > Restoring PR changes ...');
              await printAndExec('git', ['reset', '--hard', head]);
              print('> > Rebuilding PR changes ...');
              await printAndExec('make', ['get']);
              await printAndExec('make', ['localization']);
              await printAndExec('make', ['build_runner']);
            }
          },
        );
      },
      after: () async {
        if (gitStatus.isNotEmpty) {
          print('x x Something happened. Reseting to HEAD~1...');
          await printAndExec('git', ['reset', 'HEAD~1']);
        }
      },
    );
  }
}

Future<T> runGuarded<T>({
  required Future<void> Function() before,
  required Future<void> Function() after,
  required Future<T> Function() body,
}) async {
  await before();
  T? result;
  Object? error1;
  Object? error2;
  try {
    result = await body();
  } catch (error, stack) {
    error1 = Exception('$error\n$stack');
  } finally {
    try {
      await after();
    } catch (error, stack) {
      error2 = Exception('$error\n$stack');
    }
    if (error1 != null) {
      if (error2 != null) {
        // ignore: throw_in_finally, only_throw_errors
        throw MultiException(error1, error2);
      } else {
        // ignore: throw_in_finally, only_throw_errors
        throw error1;
      }
    } else if (error2 != null) {
      // ignore: throw_in_finally, only_throw_errors
      throw error2;
    }
  }
  return result as T;
}

Future<String> printAndExec(String executable, List<String> arguments, {String? workingDirectory}) {
  print('\$ ${commandLine(executable, arguments)}');
  return exec(executable, arguments, workingDirectory: workingDirectory);
}

Future<String> exec(String executable, List<String> arguments, {String? workingDirectory}) async {
  final processResult = await Process.run(executable, arguments, workingDirectory: workingDirectory);
  if (processResult.exitCode != 0) {
    throw Exception(
      '''
      ${commandLine(executable, arguments)}
      failed with exit code ${processResult.exitCode}
      stdout:
      ${indent(processResult.stdout as String)}
      stderr:
      ${indent(processResult.stderr as String)}
      ''',
    );
  }
  return (processResult.stdout as String).trim();
}

String commandLine(String executable, List<String> arguments) {
  return [executable, ...arguments].map((s) {
    if (s.contains(' ')) {
      return "'$s'";
    }
    return s;
  }).join(' ');
}

String indent(String s) => s.split('\n').map((line) => '    $line').join('\n');

extension NameExtension on FileSystemEntity {
  String get name => path.substring(path.lastIndexOf('/') + 1);
}

class MultiException implements Exception {
  MultiException(Object error1, Object error2)
      : errors = [
          if (error1 is MultiException) ...error1.errors else error1,
          error2,
        ];

  final List<Object> errors;

  @override
  String toString() => 'Several errors occurred:\n${errors.join('\n\n')}';
}
