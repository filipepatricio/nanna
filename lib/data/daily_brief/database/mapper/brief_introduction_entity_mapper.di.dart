import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_introduction_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_introduction.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefIntroductionEntityMapper implements BidirectionalMapper<BriefIntroductionEntity, BriefIntroduction> {
  @override
  BriefIntroductionEntity from(BriefIntroduction data) {
    return BriefIntroductionEntity(
      text: data.text,
      icon: data.icon,
    );
  }

  @override
  BriefIntroduction to(BriefIntroductionEntity data) {
    return BriefIntroduction(
      text: data.text,
      icon: data.icon,
    );
  }
}
