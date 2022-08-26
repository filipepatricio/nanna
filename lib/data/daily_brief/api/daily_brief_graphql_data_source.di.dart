import 'dart:async';
import 'dart:convert';

import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/documents/__generated__/current_brief.ast.gql.dart'
    as current_brief;
import 'package:better_informed_mobile/data/daily_brief/api/documents/__generated__/past_days_briefs.ast.gql.dart'
    as past_days_briefs;
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/past_days_brief_dto.dt.dart';
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
  Future<BriefDTO> currentBrief() async {
    final result = await _client.query(
      QueryOptions(
        document: current_brief.document,
        operationName: current_brief.currentBriefForStartupScreen.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => BriefDTO.fromJson(raw),
      rootKey: 'currentBrief',
    );

    return dto ?? (throw Exception('Current brief is null'));
  }

  @override
  Future<List<PastDaysBriefDTO>> pastDaysBriefs() async {
    final result = await _client.query(
      QueryOptions(
        document: past_days_briefs.document,
        operationName: past_days_briefs.getPastDaysBriefs.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final pastDaysbriefsRaw = raw['getPastDaysBriefs'] as List<dynamic>;
        final pastDaysbriefs = pastDaysbriefsRaw
            .map((json) => PastDaysBriefDTO.fromJson(json as Map<String, dynamic>))
            .toList(growable: false);

        return pastDaysbriefs;
      },
    );

    return dto ?? (throw Exception('Past days briefs is null'));
  }

  @override
  Stream<BriefDTO?> currentBriefStream() async* {
    final observableQuery = _client.watchQuery(
      WatchQueryOptions(
        document: current_brief.document,
        operationName: current_brief.currentBriefForStartupScreen.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        pollInterval: const Duration(minutes: 10),
        fetchResults: true,
        eagerlyFetchResults: false,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    yield* observableQuery.stream.map(
      (result) => _responseResolver.resolve<BriefDTO?>(
        result,
        (raw) {
          final newBriefHashCode = jsonEncode(raw).hashCode;
          if (_currentBriefHashCode == newBriefHashCode) {
            return null;
          }
          _currentBriefHashCode = newBriefHashCode;
          return BriefDTO.fromJson(raw);
        },
        rootKey: 'currentBrief',
      ),
    );
  }
}
