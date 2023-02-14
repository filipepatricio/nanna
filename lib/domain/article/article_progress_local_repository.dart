import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';

abstract class ArticleProgressLocalRepository extends SynchronizableRepository<ArticleProgress> {
  Future<void> deleteAll();
}
