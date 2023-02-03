import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/use_case/load_local_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleHeaderUseCase {
  GetArticleHeaderUseCase(
    this._articleRepository,
    this._loadLocalArticleUseCase,
  );

  final ArticleRepository _articleRepository;
  final LoadLocalArticleUseCase _loadLocalArticleUseCase;

  Future<MediaItemArticle> call(String slug) async {
    try {
      return await _articleRepository.getArticleHeader(slug);
    } on NoInternetConnectionException {
      final localArticle = await _loadLocalArticleUseCase(slug);

      if (localArticle != null) {
        return localArticle.metadata;
      }

      rethrow;
    }
  }
}
