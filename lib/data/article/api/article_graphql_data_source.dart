import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/article_gql.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const CONTENT_KEY = 'text';

@LazySingleton(as: ArticleApiDataSource)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  final GraphQLClient _client;

  ArticleGraphqlDataSource(this._client);

  @override
  Future<ArticleContentDTO> getArticleContent(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: ArticleGQL.articleContent(slug),
      ),
    );

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) {
        final content = raw[CONTENT_KEY] as Map<String, dynamic>;
        return ArticleContentDTO.fromJson(content);
      },
      rootKey: 'article',
    );

    if (dto == null) throw Exception('ArticleContent is null');

    return dto;
  }
}
