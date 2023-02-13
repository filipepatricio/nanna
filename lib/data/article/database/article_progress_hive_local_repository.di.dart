import 'package:better_informed_mobile/data/article/database/entity/article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/synchronizable_article_progress_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:hive/hive.dart';

const _boxName = 'article_progress_box';

class ArticleProgressHiveLocalRepository implements ArticleProgressLocalRepository {
  ArticleProgressHiveLocalRepository(this._box, this._mapper);

  static Future<ArticleProgressHiveLocalRepository> create(SynchronizableArticleProgressEntityMapper mapper) async {
    final box = await Hive.openLazyBox<SynchronizableEntity<ArticleProgressEntity>>(_boxName);
    return ArticleProgressHiveLocalRepository(box, mapper);
  }

  final SynchronizableArticleProgressEntityMapper _mapper;
  final LazyBox<SynchronizableEntity<ArticleProgressEntity>> _box;

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  Future<List<String>> getAllIds() async {
    return _box.keys.cast<String>().toList(growable: false);
  }

  @override
  Future<Synchronizable<ArticleProgress>?> load(String id) async {
    final synchronizableEntity = await _box.get(id);

    if (synchronizableEntity == null) {
      return null;
    }

    return _mapper.to(synchronizableEntity);
  }

  @override
  Future<void> save(Synchronizable<ArticleProgress> synchronizable) async {
    final synchronizableEntity = _mapper.from(synchronizable);
    await _box.put(synchronizableEntity.dataId, synchronizableEntity);
  }
}
