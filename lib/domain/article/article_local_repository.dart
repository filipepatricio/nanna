import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';

abstract class ArticleLocalRepository implements SynchronizableRepository<Article> {
  Future<void> deleteAll();
}
