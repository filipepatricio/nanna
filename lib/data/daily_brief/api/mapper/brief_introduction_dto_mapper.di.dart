import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_introduction_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_introduction.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefIntroductionDTOMapper implements Mapper<BriefIntroductionDTO, BriefIntroduction> {
  @override
  BriefIntroduction call(BriefIntroductionDTO data) {
    return BriefIntroduction(
      text: data.text,
      icon: data.icon,
    );
  }
}
