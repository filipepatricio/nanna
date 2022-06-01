import 'dart:convert';

import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_highlighted_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExploreContentApiDataSource, env: liveEnvs)
class ExploreContentGraphqlDataSource implements ExploreContentApiDataSource {
  ExploreContentGraphqlDataSource(
    this._client,
    this._responseResolver,
  );

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  int? _exploreHighlightedContentHashCode;

  @override
  Future<ExploreHighlightedContentDTO> getExploreHighlightedContent() async {
    final result = await _client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: ExploreContentGQL.highlightedContent(),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ExploreHighlightedContentDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Explore highlighted content can not be null'));
  }

  @override
  Future<ExploreContentAreaDTO> getPaginatedExploreArea(String id, int limit, int offset) async {
    final result = await _client.query(
      QueryOptions(
        document: ExploreContentGQL.paginated(id, limit, offset),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ExploreContentAreaDTO.fromJson(raw),
      rootKey: 'getExploreArea',
    );

    return dto ?? (throw Exception('Explore content area can not be null'));
  }

  @override
  Stream<ExploreHighlightedContentDTO?> exploreHighlightedContentStream() async* {
    final observableQuery = _client.watchQuery(
      WatchQueryOptions(
        document: ExploreContentGQL.highlightedContent(),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        pollInterval: const Duration(minutes: 10),
        fetchResults: true,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    yield* observableQuery.stream.map(
      (result) => _responseResolver.resolve<ExploreHighlightedContentDTO?>(
        result,
        (raw) {
          final newHashCode = jsonEncode(raw).hashCode;
          if (_exploreHighlightedContentHashCode == newHashCode) {
            return null;
          }
          _exploreHighlightedContentHashCode = newHashCode;
          return ExploreHighlightedContentDTO.fromJson(raw);
        },
      ),
    );
  }
}
