import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveArticleLocallyUseCase {
  SaveArticleLocallyUseCase(
    this._articleRepository,
    this._articleLocalRepository,
    this._getArticleUseCase,
    this._saveSynchronizableItemUseCase,
  );

  final ArticleRepository _articleRepository;
  final ArticleLocalRepository _articleLocalRepository;
  final GetArticleUseCase _getArticleUseCase;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;

  Future<void> fetchAndSave(String slug, Duration timeToExpire) async {
    final synchronizable = Synchronizable.notSynchronized<Article>(slug, timeToExpire);
    await _saveSynchronizableItemUseCase(_articleLocalRepository, synchronizable);

    final header = await _articleRepository.getArticleHeader(slug);

    await fetchDetailsAndSave(header, timeToExpire);
  }

  Future<void> fetchDetailsAndSave(MediaItemArticle article, Duration timeToExpire) async {
    final synchronizable = Synchronizable.notSynchronized<Article>(article.slug, timeToExpire);
    await _saveSynchronizableItemUseCase(_articleLocalRepository, synchronizable);

    final fullArticle = await _getArticleUseCase(article);

    await save(fullArticle, timeToExpire);
  }

  Future<void> save(Article article, Duration timeToExpire) async {
    final synchronizable = Synchronizable.synchronized(article, article.metadata.slug, timeToExpire);

    await _saveSynchronizableItemUseCase(_articleLocalRepository, synchronizable);
  }
}
