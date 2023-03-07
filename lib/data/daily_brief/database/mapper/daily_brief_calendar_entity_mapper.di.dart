import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_calendar_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_calendar.dt.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

@injectable
class DailyBriefCalendarEntityMapper implements BidirectionalMapper<BriefCalendarEntity, BriefCalendar> {
  @override
  BriefCalendarEntity from(BriefCalendar data) {
    return BriefCalendarEntity(
      current: data.current.toIso8601String(),
      pastItems: data.pastItems.map((e) => e.toIso8601String()).toList(),
    );
  }

  @override
  BriefCalendar to(BriefCalendarEntity data) {
    return BriefCalendar(
      current: DateTime.parse(data.current),
      pastItems: data.pastItems.map((e) => DateTime.parse(e)).sortedBy((element) => element).toList(),
    );
  }
}
