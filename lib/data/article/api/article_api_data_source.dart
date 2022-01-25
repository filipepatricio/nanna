import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';

abstract class ArticleApiDataSource {
  Future<ArticleDTO> getFullArticle(String slug);
  Future<ArticleContentDTO> getArticleContent(String slug);
}
