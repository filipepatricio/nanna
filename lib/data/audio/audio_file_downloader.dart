import 'dart:io';

import 'package:better_informed_mobile/domain/audio/exception/file_access_expired.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AudioFileDownloader {
  Future<void> loadAndSaveFile(File file, String url) async {
    final args = _AudioFileArgs(file, url);
    await compute(_loadAndSave, args);
  }

  static Future<void> _loadAndSave(_AudioFileArgs args) async {
    final client = HttpClient();

    try {
      final uri = Uri.parse(args.url);
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == HttpStatus.forbidden) {
        throw FileAccessExpired();
      } else if (response.statusCode != HttpStatus.ok) {
        throw Exception('Loading pdf failed with code ${response.statusCode}');
      }

      await response.pipe(args.file.openWrite());
    } finally {
      client.close(force: true);
    }
  }
}

class _AudioFileArgs {
  _AudioFileArgs(
    this.file,
    this.url,
  );

  final File file;
  final String url;
}
