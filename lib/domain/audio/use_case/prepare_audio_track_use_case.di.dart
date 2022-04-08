import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/exception/file_access_expired.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class PrepareArticleAudioTrackUseCase {
  PrepareArticleAudioTrackUseCase(
    this._audioRepository,
    this._articleRepository,
  );

  final AudioRepository _audioRepository;
  final ArticleRepository _articleRepository;

  Future<void> call({
    required MediaItemArticle article,
    String? imageUrl,
  }) async {
    final audioFile = await _articleRepository.getArticleAudioFile(article.slug);

    final item = AudioItem(
      title: article.strippedTitle,
      author: article.publisher.name,
      fileUrl: audioFile.url,
      imageUrl: imageUrl,
    );

    try {
      await _audioRepository.prepareItem(item);
    } on FileAccessExpired catch (_) {
      final audioFile = await _articleRepository.getArticleAudioFile(
        article.slug,
        true,
      );
      final freshItem = item.copyWith(fileUrl: audioFile.url);
      await _audioRepository.prepareItem(freshItem);
    }
  }
}
