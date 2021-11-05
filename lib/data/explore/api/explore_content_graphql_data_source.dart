import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExploreContentApiDataSource)
class ExploreContentGraphqlDataSource implements ExploreContentApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  ExploreContentGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<ExploreContentDTO> getExploreContent() async {
    final result = await _client.query(
      QueryOptions(
        document: ExploreContentGQL.content(),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ExploreContentDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Explore content can not be null'));
  }
}
