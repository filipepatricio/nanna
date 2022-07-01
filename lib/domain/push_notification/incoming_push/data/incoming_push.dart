import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dt.dart';

class IncomingPush {
  IncomingPush(this.actions);
  final List<IncomingPushAction> actions;
}
