import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ArticleApiDataSource, env: mockEnvs)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  @override
  Future<ArticleContentDTO> getArticleContent(String slug) async {
    return MockDTO.articleContentMarkdown;
  }

  @override
  Future<ArticleDTO> getFullArticle(String slug) async {
    return MockDTO.premiumArticle;
  }

  @override
  Future<ArticleDTO> getArticleHeader(String slug) async {
    return MockDTO.premiumArticle;
  }
}
