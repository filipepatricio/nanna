import 'dart:async';
import 'dart:convert';

import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/documents/__generated__/current_brief.ast.gql.dart'
    as current_brief;
import 'package:better_informed_mobile/data/daily_brief/api/documents/__generated__/get_brief_by_date.ast.gql.dart'
    as get_brief_by_date;
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/briefs_wrapper_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:fimber/fimber.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource, env: defaultEnvs)
class DailyBriefGraphqlDataSource implements DailyBriefApiDataSource {
  DailyBriefGraphqlDataSource(this._client, this._responseResolver);

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  int? _currentBriefHashCode;

  @override
  Future<BriefsWrapperDTO> currentBrief() async {
    final result = await _client.query(
      QueryOptions(
        document: current_brief.document,
        operationName: current_brief.currentBriefForStartupScreen.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => BriefsWrapperDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Current brief is null'));
  }

  @override
  Future<BriefDTO> pastBrief(DateTime dateTime) async {
    final formattedTime = DateFormat('y-MM-dd').format(dateTime);
    Fimber.d('Formatted time: $formattedTime');

    final result = await _client.query(
      QueryOptions(
        document: get_brief_by_date.document,
        operationName: get_brief_by_date.getBriefByDate.name?.value,
        variables: {
          'date': formattedTime,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => BriefDTO.fromJson(raw),
      rootKey: 'getBriefByDate',
    );

    return dto ?? (throw Exception('Brief for $dateTime is null'));
  }

  @override
  Stream<BriefsWrapperDTO?> currentBriefStream() async* {
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
      (result) => _responseResolver.resolve<BriefsWrapperDTO?>(
        result,
        (raw) {
          final newBriefHashCode = jsonEncode(raw).hashCode;
          if (_currentBriefHashCode == newBriefHashCode) {
            return null;
          }
          _currentBriefHashCode = newBriefHashCode;
          return BriefsWrapperDTO.fromJson(raw);
        },
      ),
    );
  }
}
