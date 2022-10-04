import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleUseCase {
  GetArticleUseCase(
    this._articleRepository,
  );
  final ArticleRepository _articleRepository;

  Future<Article> call(MediaItemArticle article) async {
    final content = await _articleRepository.getArticleContent(article.slug);

    final shouldGetAudioFile = article.hasAudioVersion && article.availableInSubscription;
    final audioFile = shouldGetAudioFile ? await _articleRepository.getArticleAudioFile(article.slug) : null;

    return Article(
      content: content,
      metadata: article,
      audioFile: audioFile,
    );
  }
}
