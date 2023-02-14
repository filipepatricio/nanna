import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ArticleLocalRepository, env: mockEnvs)
class ArticleLocalRepositoryMock implements ArticleLocalRepository {
  @override
  Future<void> deleteAll() async {}

  @override
  Future<void> delete(String slug) async {}

  @override
  Future<Synchronizable<Article>?> load(String slug) async {
    return null;
  }

  @override
  Future<void> save(Synchronizable<Article> article) async {}

  @override
  Future<List<String>> getAllIds() async {
    return [];
  }
}
