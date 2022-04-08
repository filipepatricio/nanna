import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_gql.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource, env: liveEnvs)
class DailyBriefGraphqlDataSource implements DailyBriefApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  DailyBriefGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<CurrentBriefDTO> currentBrief() async {
    final result = await _client.query(
      QueryOptions(
        document: DailyBriefGql.currentBrief(),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => CurrentBriefDTO.fromJson(raw),
      rootKey: 'currentBrief',
    );

    return dto ?? (throw Exception('Current brief is null'));
  }
}