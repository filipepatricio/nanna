import 'dart:convert';

import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/util/mock_graphql_responses.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ArticleApiDataSource, env: mockEnvs)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  @override
  Future<ArticleContentDTO> getArticleContent(String slug) async {
    final dto = ArticleContentDTO.fromJson(
      jsonDecode(MockGraphqlResponses.arzticleContentMarkdown) as Map<String, dynamic>,
    );
    return dto;
  }

  @override
  Future<ArticleDTO> getFullArticle(String slug) async {
    return ArticleDTO.fromJson(jsonDecode(MockGraphqlResponses.article) as Map<String, dynamic>);
  }

  @override
  Future<ArticleDTO> getArticleHeader(String slug) async {
    return ArticleDTO.fromJson(jsonDecode(MockGraphqlResponses.article) as Map<String, dynamic>);
  }
}
