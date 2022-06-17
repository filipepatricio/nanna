import 'dart:async';
import 'dart:convert';

import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/documents/__generated__/current_brief.ast.gql.dart'
    as current_brief;
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource, env: liveEnvs)
class DailyBriefGraphqlDataSource implements DailyBriefApiDataSource {
  DailyBriefGraphqlDataSource(this._client, this._responseResolver);

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  int? _currentBriefHashCode;

  @override
  Future<CurrentBriefDTO> currentBrief() async {
    final result = await _client.query(
      QueryOptions(
        document: current_brief.document,
        operationName: current_brief.currentBriefForStartupScreen.name?.value,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => CurrentBriefDTO.fromJson(raw),
      rootKey: 'currentBrief',
    );

    return dto ?? (throw Exception('Current brief is null'));
  }

  @override
  Stream<CurrentBriefDTO?> currentBriefStream() async* {
    final observableQuery = _client.watchQuery(
      WatchQueryOptions(
        document: current_brief.document,
        operationName: current_brief.currentBriefForStartupScreen.name?.value,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        pollInterval: const Duration(minutes: 10),
        fetchResults: true,
        eagerlyFetchResults: false,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    yield* observableQuery.stream.map(
      (result) => _responseResolver.resolve<CurrentBriefDTO?>(
        result,
        (raw) {
          final newBriefHashCode = jsonEncode(raw).hashCode;
          if (_currentBriefHashCode == newBriefHashCode) {
            return null;
          }
          _currentBriefHashCode = newBriefHashCode;
          return CurrentBriefDTO.fromJson(raw);
        },
        rootKey: 'currentBrief',
      ),
    );
  }
}
