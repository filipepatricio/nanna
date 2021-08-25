import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/article_gql.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ArticleApiDataSource)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  final GraphQLClient _client;

  ArticleGraphqlDataSource(this._client);

  @override
  Future<ArticleDTO> getFullArticle(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: ArticleGQL.fullArticle(slug),
      ),
    );

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => ArticleDTO.fromJson(raw),
      rootKey: 'article',
    );

    if (dto == null) throw Exception('Article is null');

    return dto;
  }
}
