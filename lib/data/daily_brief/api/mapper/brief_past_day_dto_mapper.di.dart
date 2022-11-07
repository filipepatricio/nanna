import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_past_day_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefPastDayDTOMapper implements Mapper<BriefPastDayDTO, BriefPastDay> {
  @override
  BriefPastDay call(BriefPastDayDTO data) {
    return BriefPastDay(
      DateTime.parse(data.date),
      data.hasBrief,
    );
  }
}
