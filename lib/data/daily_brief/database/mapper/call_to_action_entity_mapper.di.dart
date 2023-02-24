import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/call_to_action_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/call_to_action.dart';
import 'package:injectable/injectable.dart';

@injectable
class CallToActionEntityMapper implements BidirectionalMapper<CallToActionEntity, CallToAction> {
  @override
  CallToActionEntity from(CallToAction data) {
    return CallToActionEntity(
      preText: data.preText,
      actionText: data.actionText,
    );
  }

  @override
  CallToAction to(CallToActionEntity data) {
    return CallToAction(
      actionText: data.actionText,
      preText: data.preText,
    );
  }
}
