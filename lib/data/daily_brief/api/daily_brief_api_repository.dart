import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefRepository)
class DailyBriefApiRepository implements DailyBriefRepository {
  final DailyBriefApiDataSource _dailyBriefApiDataSource;

  DailyBriefApiRepository(this._dailyBriefApiDataSource);

  @override
  Future<CurrentBrief> getCurrentBrief() {
    // TODO: implement getCurrentBrief
    throw UnimplementedError();
  }
}
