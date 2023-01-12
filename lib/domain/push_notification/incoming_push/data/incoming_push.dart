import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dt.dart';
import 'package:flutter/foundation.dart';

class IncomingPush {
  IncomingPush(this.actions);
  final List<IncomingPushAction> actions;

  @override
  bool operator ==(covariant IncomingPush other) {
    if (identical(this, other)) return true;

    return listEquals(other.actions, actions);
  }

  @override
  int get hashCode => actions.hashCode;
}
