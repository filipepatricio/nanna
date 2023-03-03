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

  Future<Article> call(
    MediaItemArticle article, {
    bool refreshMetadata = false,
  }) async {
    try {
      return await _getRemote(article, refreshMetadata);
    } on NoInternetConnectionException {
      final localArticle = await _loadLocalArticleUseCase(article.slug);

      if (localArticle != null) {
        return localArticle;
      }

      rethrow;
    }
  }

  Future<Article> _getRemote(MediaItemArticle article, bool refreshMetadata) async {
    final content = await _articleRepository.getArticleContent(article.slug);
    final metadata = refreshMetadata ? await _articleRepository.getArticleHeader(article.slug) : article;

    final audioFile = metadata.canGetAudioFile ? await _articleRepository.getArticleAudioFile(article.slug) : null;

    return Article(
      content: content,
      metadata: metadata,
      audioFile: audioFile,
    );
  }
}
