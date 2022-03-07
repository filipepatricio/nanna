import 'dart:io';

import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<File> generateShareImage(ShareViewImageGenerator generator, String fileName) async {
  final imageBytes = await generator.generate();

  if (imageBytes != null) {
    final tempDir = await getTemporaryDirectory();
    final shareImagePath = join(tempDir.path, fileName);
    final file = File(shareImagePath);
    await file.writeAsBytes(imageBytes.buffer.asInt8List());

    return file;
  }

  throw Exception('Share image file generation failed.');
}
