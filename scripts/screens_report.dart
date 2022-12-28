// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

final goldensDir = Directory('test/visual/goldens');
final reportDir = Directory('test/visual/screens_report');
final cacheRoot = Directory('${Directory.systemTemp.path}/informed_goldens');

Future<void> main(List<String> args) async {
  try {
    await createVisualChangesReport();
  } catch (error, stack) {
    stderr
      ..writeln(error)
      ..writeln(stack);
    exit(3);
  }
}

Future<void> createVisualChangesReport() async {
  if (!goldensDir.existsSync()) {
    stderr.writeln('Error: ${goldensDir.path} does not exist');
    exit(2);
  }
  final goldenImages = goldensDir.listSync().where((x) => x is File && x.path.endsWith('.png'));
  if (goldenImages.isEmpty) {
    stderr.writeln('Error: ${goldensDir.path} does not contain any golden images');
    exit(2);
  }
  if (reportDir.existsSync()) {
    await reportDir.delete(recursive: true);
  }
  await reportDir.create();
  final imagePrefixes = <String>{};
  for (final testImage in goldenImages) {
    imagePrefixes.add(testImage.name.basePart);
  }
  print('creating report for prefixes: ${imagePrefixes.join(',')}');

  for (final prefix in imagePrefixes) {
    final goldenImagesWithPrefix =
        goldenImages.where((image) => image.name.basePart == prefix).map((image) => image.name).toList();

    goldenImagesWithPrefix.sort((a, b) => b.modePart.compareTo(a.modePart));
    goldenImagesWithPrefix.sort((a, b) => b.devicePart.compareTo(a.devicePart));

    await printAndExec(
      'convert',
      [
        ...goldenImagesWithPrefix,
        '+append',
        '../screens_report/$prefix.png',
      ],
      workingDirectory: goldensDir.path,
    );
  }
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

extension ImageFileParts on String {
  String get basePart => split('.').first;
  String get modePart => split('.')[1];
  String get devicePart => split('.')[2];
}
