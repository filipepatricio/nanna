import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_action_dto_mapper.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingPushDTOMapper implements Mapper<IncomingPushDTO, IncomingPush> {
  final IncomingPushActionDTOMapper _actionDTOMapper;

  IncomingPushDTOMapper(this._actionDTOMapper);

  @override
  IncomingPush call(IncomingPushDTO data) {
    final actions = data.actions.map<IncomingPushAction>(_actionDTOMapper).toList(growable: false);
    return IncomingPush(actions);
  }
}
