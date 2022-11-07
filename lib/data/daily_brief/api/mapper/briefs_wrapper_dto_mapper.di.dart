import 'package:better_informed_mobile/data/daily_brief/api/dto/briefs_wrapper_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_past_day_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_wrapper.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefsWrapperDTOMapper implements Mapper<BriefsWrapperDTO, BriefsWrapper> {
  BriefsWrapperDTOMapper(
    this._briefDTOMapper,
    this._briefPastDaysDTOMapper,
  );

  final BriefDTOMapper _briefDTOMapper;
  final BriefPastDayDTOMapper _briefPastDaysDTOMapper;

  @override
  BriefsWrapper call(BriefsWrapperDTO data) {
    final pastDays = data.pastDays.map<BriefPastDay>(_briefPastDaysDTOMapper).toList(growable: false);

    return BriefsWrapper(
      _briefDTOMapper(data.currentBrief),
      BriefPastDays(pastDays),
    );
  }
}
