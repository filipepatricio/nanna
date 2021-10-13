import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';

abstract class ArticleApiDataSource {
  Future<ArticleContentDTO> getArticleContent(String slug);
}
