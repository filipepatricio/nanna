import 'dart:convert';

import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

const _typeKey = 'type';
const _argsKey = 'args';

const _actionsKey = 'actions';
const _metadataKey = 'meta';
const _badgeCountKey = 'badge_count';
const _badgeCountDecodedKey = 'badgeCount';
const _reasonKey = 'reason';

@injectable
class RemoteMessageToIncomingPushDTOMapper implements Mapper<RemoteMessage, IncomingPushDTO> {
  @override
  IncomingPushDTO call(RemoteMessage message) {
    final decodedActions =
        message.data.containsKey(_actionsKey) ? jsonDecode(message.data[_actionsKey] as String) : null;
    final decodedMeta =
        message.data.containsKey(_metadataKey) ? jsonDecode(message.data[_metadataKey] as String) : null;

    final decodedReason = message.data.containsKey(_reasonKey) ? message.data[_reasonKey] as String : null;
    final decodedBadgeCount =
        message.data.containsKey(_badgeCountKey) ? int.parse(message.data[_badgeCountKey] as String) : null;

    final badgeCountToActionsJson = [
      {
        _argsKey: {_badgeCountDecodedKey: decodedBadgeCount},
        _typeKey: decodedReason,
      }
    ];

    final fixedJson = {
      _actionsKey: decodedActions ?? badgeCountToActionsJson,
      _metadataKey: decodedMeta,
    };

    return IncomingPushDTO.fromJson(fixedJson);
  }
}
