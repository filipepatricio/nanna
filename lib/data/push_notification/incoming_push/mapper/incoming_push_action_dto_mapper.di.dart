import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_action_dto.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingPushActionDTOMapper implements Mapper<IncomingPushActionDTO, IncomingPushAction> {
  @override
  IncomingPushAction call(IncomingPushActionDTO data) {
    return data.map(
      refreshDailyBrief: (data) => IncomingPushAction.refreshDailyBrief(),
      navigateTo: (data) => IncomingPushAction.navigateTo(data.args.path),
      unknown: (data) => IncomingPushAction.unknown(data.type),
      briefEntrySeenByUser: (data) => IncomingPushAction.briefEntrySeenByUser(data.args.badgeCount),
      briefEntriesUpdated: (data) => IncomingPushAction.briefEntriesUpdated(data.args.badgeCount),
      newBriefPublished: (data) => IncomingPushAction.newBriefPublished(data.args.badgeCount),
    );
  }
}
