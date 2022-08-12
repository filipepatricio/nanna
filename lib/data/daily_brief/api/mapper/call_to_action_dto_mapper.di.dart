import 'package:better_informed_mobile/data/daily_brief/api/dto/call_to_action_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/call_to_action.dart';
import 'package:injectable/injectable.dart';

@injectable
class CallToActionDTOMapper extends Mapper<CallToActionDTO?, CallToAction?> {
  @override
  CallToAction? call(CallToActionDTO? data) {
    if (data == null) return null;

    return CallToAction(
      actionText: data.actionText,
      preText: data.preText,
    );
  }
}
