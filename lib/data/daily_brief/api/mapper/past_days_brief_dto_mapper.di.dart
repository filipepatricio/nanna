import 'package:better_informed_mobile/data/daily_brief/api/dto/past_days_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_dto_mapper.di.dart';

import 'package:better_informed_mobile/data/mapper.dart';

import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class PastDaysBriefDTOMapper implements Mapper<PastDaysBriefDTO, PastDaysBrief> {
  const PastDaysBriefDTOMapper(this._briefDTOMapper);

  final BriefDTOMapper _briefDTOMapper;

  @override
  PastDaysBrief call(PastDaysBriefDTO data) {
    return PastDaysBrief(
      brief: data.brief != null ? _briefDTOMapper(data.brief!) : null,
      date: data.date,
    );
  }
}
