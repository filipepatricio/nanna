import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_push_action.freezed.dart';

@freezed
class IncomingPushAction with _$IncomingPushAction {
  factory IncomingPushAction.refreshDailyBrief() = _IncomingPushActionRefreshDailyBrief;

  factory IncomingPushAction.navigateTo(String path) = _IncomingPushActionNavigateTo;

  factory IncomingPushAction.unknown(String type) = _IncomingPushActionUnknown;
}
