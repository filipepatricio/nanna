import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

const _daysToExpire = 7;

@injectable
class SaveArticleLocallyUseCase {
  SaveArticleLocallyUseCase(
    this._articleRepository,
    this._articleLocalRepository,
    this._getArticleUseCase,
  );

  final ArticleRepository _articleRepository;
  final ArticleLocalRepository _articleLocalRepository;
  final GetArticleUseCase _getArticleUseCase;

  Future<void> fetchAndSave(String slug) async {
    final header = await _articleRepository.getArticleHeader(slug);

    await fetchDetailsAndSave(header);
  }

  Future<void> fetchDetailsAndSave(MediaItemArticle article) async {
    final fullArticle = await _getArticleUseCase(article);

    await save(fullArticle);
  }

  Future<void> save(Article article) async {
    await _articleLocalRepository.saveArticle(
      _getSynchronizableArticle(article),
    );
  }

  Synchronizable<Article> _getSynchronizableArticle(Article article) {
    final syncDate = clock.now();

    return Synchronizable(
      data: article,
      expirationDate: _getExpirationDate(syncDate),
      synchronizedAt: syncDate,
      createdAt: syncDate,
    );
  }

  DateTime _getExpirationDate(DateTime syncDate) {
    return syncDate.add(const Duration(days: _daysToExpire));
  }
}
