import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_push_action.dt.freezed.dart';

@Freezed(toJson: false)
class IncomingPushAction with _$IncomingPushAction {
  factory IncomingPushAction.refreshDailyBrief() = IncomingPushActionRefreshDailyBrief;

  factory IncomingPushAction.navigateTo(String path) = IncomingPushActionNavigateTo;

  factory IncomingPushAction.unknown(String type) = IncomingPushActionUnknown;
}
