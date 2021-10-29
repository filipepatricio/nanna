import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_gql.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource)
class DailyBriefGraphqlDataSource implements DailyBriefApiDataSource {
  final GraphQLClient _client;

  DailyBriefGraphqlDataSource(this._client);

  @override
  Future<CurrentBriefDTO> currentBrief() async {
    final result = await _client.query(
      QueryOptions(
        document: DailyBriefGql.currentBrief(),
      ),
    );

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => CurrentBriefDTO.fromJson(raw),
      rootKey: 'currentBrief',
    );

    return dto ?? (throw Exception('Current brief is null'));
  }
}