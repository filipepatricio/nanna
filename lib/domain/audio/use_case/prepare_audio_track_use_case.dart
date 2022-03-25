import 'dart:io';

import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class PrepareAudioTrackUseCase {
  PrepareAudioTrackUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Future<void> call(MediaItemArticle article, String? imageUrl) async {
    final mp3 = await rootBundle.load('assets/audio/yes.mp3');

    final tmpDir = await getTemporaryDirectory();
    final fileName = join(tmpDir.path, 'yes.mp3');
    final file = File(fileName);
    await file.writeAsBytes(mp3.buffer.asInt8List());

    final item = AudioItem(
      file: file,
      title: article.strippedTitle,
      publisher: article.publisher.name,
      imageUrl: imageUrl,
    );

    await _audioRepository.prepareItem(item);
  }
}
