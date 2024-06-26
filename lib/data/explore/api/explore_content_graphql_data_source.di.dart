import 'dart:convert';

import 'package:better_informed_mobile/core/di/network_module.di.dart';
import 'package:better_informed_mobile/data/explore/api/documents/__generated__/get_explore_area.ast.gql.dart'
    as get_explore_area;
import 'package:better_informed_mobile/data/explore/api/documents/__generated__/get_explore_section.ast.gql.dart'
    as get_explore_section;
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExploreContentApiDataSource, env: defaultEnvs)
class ExploreContentGraphqlDataSource implements ExploreContentApiDataSource {
  ExploreContentGraphqlDataSource(
    this._client,
    @Named(guestGQLClientName) this._guestClient,
    this._responseResolver,
  );

  final GraphQLClient _client;
  final GraphQLClient _guestClient;
  final GraphQLResponseResolver _responseResolver;

  ObservableQuery<Object>? _exploreContentObservable;

  int? _exploreContentHashCode;

  @override
  Future<ExploreContentDTO> getExploreContent() async {
    final result = await _client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: get_explore_section.document,
        operationName: get_explore_section.getExploreSection.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ExploreContentDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Explore content can not be null'));
  }

  @override
  Future<ExploreContentDTO> getExploreContentGuest() async {
    final result = await _guestClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: get_explore_section.document,
        operationName: get_explore_section.getExploreSection.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ExploreContentDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Explore content can not be null'));
  }

  @override
  Future<ExploreContentAreaDTO> getPaginatedExploreArea(String id, int limit, int offset) async {
    final result = await _client.query(
      QueryOptions(
        document: get_explore_area.document,
        operationName: get_explore_area.getExploreArea.name?.value,
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'id': id,
          'limit': limit,
          'offset': offset,
        },
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
  Stream<ExploreContentDTO?> exploreContentStream() async* {
    _exploreContentObservable = _client.watchQuery(
      WatchQueryOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: get_explore_section.document,
        operationName: get_explore_section.getExploreSection.name?.value,
        pollInterval: const Duration(minutes: 10),
        fetchResults: true,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    yield* _exploreContentObservable!.stream.map(
      (result) => _responseResolver.resolve<ExploreContentDTO?>(
        result,
        (raw) {
          final newHashCode = jsonEncode(raw).hashCode;
          if (_exploreContentHashCode == newHashCode) {
            return null;
          }
          _exploreContentHashCode = newHashCode;
          return ExploreContentDTO.fromJson(raw);
        },
      ),
    );
  }

  @override
  @disposeMethod
  void dispose() {
    _exploreContentObservable?.close();
  }
}
