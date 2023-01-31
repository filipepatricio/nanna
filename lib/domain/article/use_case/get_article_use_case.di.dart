import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dt.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleUseCase {
  GetArticleUseCase(
    this._articleRepository,
  );

  final ArticleRepository _articleRepository;

  Future<Article> call(
    MediaItemArticle article, {
    bool refreshMetadata = false,
  }) async {
    final shouldGetAudioFile = article.hasAudioVersion && article.availableInSubscription;

    final articleComponents = await Future.wait(
      [
        _articleRepository.getArticleContent(article.slug),
        if (refreshMetadata) _articleRepository.getArticleHeader(article.slug) else Future.value(article),
        if (shouldGetAudioFile) _articleRepository.getArticleAudioFile(article.slug) else Future.value(null),
      ],
    );

    return Article(
      content: articleComponents[0] as ArticleContent,
      metadata: articleComponents[1] as MediaItemArticle,
      audioFile: articleComponents[2] as AudioFile?,
    );
  }
}
