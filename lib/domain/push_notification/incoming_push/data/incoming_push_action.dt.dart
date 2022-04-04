import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_push_action.dt.freezed.dart';

@freezed
class IncomingPushAction with _$IncomingPushAction {
  factory IncomingPushAction.refreshDailyBrief() = IncomingPushActionRefreshDailyBrief;

  factory IncomingPushAction.navigateTo(String path) = IncomingPushActionNavigateTo;

  factory IncomingPushAction.unknown(String type) = IncomingPushActionUnknown;
}
