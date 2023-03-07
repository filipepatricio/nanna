import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/load_local_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleUseCase {
  GetArticleUseCase(
    this._articleRepository,
    this._loadLocalArticleUseCase,
  );

  final ArticleRepository _articleRepository;
  final LoadLocalArticleUseCase _loadLocalArticleUseCase;

  Future<Article> single(MediaItemArticle article) async {
    try {
      return await _articleRepository.getArticle(article.slug, article.canGetAudioFile);
    } on NoInternetConnectionException {
      final localArticle = await _loadLocalArticleUseCase(article.slug);

      if (localArticle != null) {
        return localArticle;
      }

      rethrow;
    }
  }

  Future<List<Article>> multiple(List<MediaItemArticle> articles) async {
    return _articleRepository.getArticleList(articles.map((item) => item.slug).toList(growable: false));
  }
}
