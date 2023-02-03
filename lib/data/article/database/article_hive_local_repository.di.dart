import 'package:better_informed_mobile/data/article/database/entity/article_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/synchronizable_article_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:hive/hive.dart';

const _boxName = 'articles';

class ArticleHiveLocalRepository implements ArticleLocalRepository {
  ArticleHiveLocalRepository._(this._articleBox, this._articleEntityMapper);

  static Future<ArticleHiveLocalRepository> create(SynchronizableArticleEntityMapper articleEntityMapper) async {
    final box = await Hive.openLazyBox<SynchronizableEntity<ArticleEntity>>(_boxName);
    return ArticleHiveLocalRepository._(box, articleEntityMapper);
  }

  final SynchronizableArticleEntityMapper _articleEntityMapper;

  final LazyBox<SynchronizableEntity<ArticleEntity>> _articleBox;

  @override
  Future<void> delete(String slug) async {
    await _articleBox.delete(slug);
  }

  @override
  Future<void> save(Synchronizable<Article> synchronizable) async {
    await _articleBox.put(
      synchronizable.dataId,
      _articleEntityMapper.from(synchronizable),
    );
  }

  @override
  Future<Synchronizable<Article>?> load(String slug) async {
    final entity = await _articleBox.get(slug);
    return entity != null ? _articleEntityMapper.to(entity) : null;
  }

  @override
  Future<void> deleteAll() async {
    await _articleBox.clear();
  }

  @override
  Future<List<String>> getAllIds() async {
    return _articleBox.keys.cast<String>().toList();
  }
}
