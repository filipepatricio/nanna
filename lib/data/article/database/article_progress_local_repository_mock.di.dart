import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:injectable/injectable.dart';

// @LazySingleton(as: ArticleLocalRepository, env: mockEnvs)
@LazySingleton(as: ArticleProgressLocalRepository)
class ArticleProgressLocalRepositoryMock implements ArticleProgressLocalRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> deleteAll() async {}

  @override
  Future<List<String>> getAllIds() async {
    return [];
  }

  @override
  Future<Synchronizable<ArticleProgress>?> load(String id) async {}

  @override
  Future<void> save(Synchronizable<ArticleProgress> synchronizable) async {}
}
