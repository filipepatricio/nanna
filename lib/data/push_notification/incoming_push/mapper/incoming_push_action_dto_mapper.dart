import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_action_dto.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingPushActionDTOMapper implements Mapper<IncomingPushActionDTO, IncomingPushAction> {
  @override
  IncomingPushAction call(IncomingPushActionDTO data) {
    return data.map(
      refreshDailyBrief: (data) => IncomingPushAction.refreshDailyBrief(),
      navigateTo: (data) {
        final path = data.args.path == '/' ? '/topics' : data.args.path;
        return IncomingPushAction.navigateTo(path);
      },
      unknown: (data) => IncomingPushAction.unknown(data.type),
    );
  }
}
