import 'dart:async';
import 'dart:convert';

import 'package:better_informed_mobile/core/di/network_module.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/documents/__generated__/current_and_past_briefs.ast.gql.dart'
    as current_and_past_briefs;
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
  DailyBriefGraphqlDataSource(
    this._client,
    @Named(guestGQLClientName) this._guestClient,
    this._responseResolver,
  );

  final GraphQLClient _client;
  final GraphQLClient _guestClient;
  final GraphQLResponseResolver _responseResolver;

  ObservableQuery<Object>? _currentBriefObservable;

  int? _currentBriefHashCode;

  @override
  Future<BriefsWrapperDTO> currentBrief() async {
    final result = await _client.query(
      QueryOptions(
        document: current_and_past_briefs.document,
        operationName: current_and_past_briefs.currentAndPastBriefs.name?.value,
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
  Future<BriefsWrapperDTO> currentBriefGuest() async {
    final result = await _guestClient.query(
      QueryOptions(
        document: current_brief.document,
        operationName: current_brief.currentBrief.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => BriefsWrapperDTO.withEmptyPastDays(raw),
      rootKey: 'currentBrief',
    );

    return dto ?? (throw Exception('Current brief (unauthorized) is null'));
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
    _currentBriefObservable = _client.watchQuery(
      WatchQueryOptions(
        document: current_and_past_briefs.document,
        operationName: current_and_past_briefs.currentAndPastBriefs.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        pollInterval: const Duration(minutes: 10),
        fetchResults: true,
        eagerlyFetchResults: false,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    yield* _currentBriefObservable!.stream.map(
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

  @override
  @disposeMethod
  void dispose() {
    _currentBriefObservable?.close();
  }
}
