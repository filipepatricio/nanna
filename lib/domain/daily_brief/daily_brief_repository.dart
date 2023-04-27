import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_wrapper.dart';

abstract class DailyBriefRepository {
  Future<BriefsWrapper> getCurrentBrief();

  Future<BriefsWrapper> getCurrentBriefUnauthorized();

  Future<Brief> getPastBrief(DateTime date);

  Stream<BriefsWrapper> currentBriefStream();
}
