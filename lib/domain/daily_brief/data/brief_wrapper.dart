import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';

class BriefsWrapper {
  BriefsWrapper(this.currentBrief, this.pastDays);

  final Brief currentBrief;
  final BriefPastDays pastDays;
}
