import 'dart:convert';

import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

const _actionsKey = 'actions';
const _metadataKey = 'meta';

@injectable
class RemoteMessageToIncomingPushDTOMapper implements Mapper<RemoteMessage, IncomingPushDTO> {
  @override
  IncomingPushDTO call(RemoteMessage message) {
    final decodedActions = jsonDecode(message.data[_actionsKey] as String);
    final decodedMeta = jsonDecode(message.data[_metadataKey] as String);

    final fixedJson = {
      _actionsKey: decodedActions,
      _metadataKey: decodedMeta,
    };

    return IncomingPushDTO.fromJson(fixedJson);
  }
}
