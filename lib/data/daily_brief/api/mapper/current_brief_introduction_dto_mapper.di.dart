import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_introduction_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief_introduction.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentBriefIntroductionDTOMapper implements Mapper<CurrentBriefIntroductionDTO, CurrentBriefIntroduction> {
  @override
  CurrentBriefIntroduction call(CurrentBriefIntroductionDTO data) {
    return CurrentBriefIntroduction(
      text: data.text,
      icon: data.icon,
    );
  }
}
