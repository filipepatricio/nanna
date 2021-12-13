import 'dart:convert';

import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dart';
import 'package:better_informed_mobile/data/util/mock_graphql_responses.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource, env: mockEnvs)
class DailyBriefMockDataSource implements DailyBriefApiDataSource {
  @override
  Future<CurrentBriefDTO> currentBrief() async {
    const result = MockGraphqlResponses.currentBrief;
    final data = jsonDecode(result) as Map<String, dynamic>;
    final dto = CurrentBriefDTO.fromJson(data['currentBrief'] as Map<String, dynamic>);

    return dto;
  }
}
