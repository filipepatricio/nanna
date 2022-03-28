import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/audio_file/audio_file_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleUseCase {
  final ArticleRepository _articleRepository;
  final AudioFileRepository _audioFileRepository;

  GetArticleUseCase(
    this._articleRepository,
    this._audioFileRepository,
  );

  Future<Article> call(MediaItemArticle article) async {
    final content = await _articleRepository.getArticleContent(article.slug);
    final audioFile = article.hasAudioVersion ? await _audioFileRepository.getArticleAudioFile(article.slug) : null;

    return Article(
      content: content,
      article: article,
      audioFile: audioFile,
    );
  }
}
