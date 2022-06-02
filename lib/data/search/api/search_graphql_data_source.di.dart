import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/search_api_data_source.dart';
import 'package:better_informed_mobile/data/search/api/search_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchApiDataSource, env: liveEnvs)
class SearchGraphqlDataSource implements SearchApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  SearchGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<SearchContentDTO> searchContent(String query, int limit, int offset) async {
    final result = await _client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: SearchGQL.search(query, limit, offset),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SearchContentDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Search content can not be null'));
  }
}