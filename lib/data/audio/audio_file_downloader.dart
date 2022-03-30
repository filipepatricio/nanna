import 'dart:io';

import 'package:better_informed_mobile/domain/audio/exception/file_access_expired.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AudioFileDownloader {
  Future<void> loadAndSaveFile(File file, String url) async {
    final args = _AudioFileArgs(file, url);
    final result = await compute(_loadAndSave, args);

    if (result != HttpStatus.ok) {
      if (result == HttpStatus.forbidden) {
        throw FileAccessExpired();
      } else if (result != HttpStatus.ok) {
        throw Exception('Loading pdf failed with code $result');
      }
    }
  }

  static Future<int> _loadAndSave(_AudioFileArgs args) async {
    final client = HttpClient();

    try {
      final uri = Uri.parse(args.url);
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        return response.statusCode;
      }

      await response.pipe(args.file.openWrite());
    } finally {
      client.close(force: true);
    }

    return HttpStatus.ok;
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
