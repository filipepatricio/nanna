import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';

abstract class ArticleLocalRepository {
  Future<void> saveArticle(Synchronizable<Article> article);

  Future<Synchronizable<Article>?> loadArticle(String slug);

  Future<void> deleteArticle(String slug);

  Future<void> deleteAll();
}
