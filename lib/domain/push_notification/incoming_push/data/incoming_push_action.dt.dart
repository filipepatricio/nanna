import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_push_action.dt.freezed.dart';

@Freezed(toJson: false)
class IncomingPushAction with _$IncomingPushAction {
  factory IncomingPushAction.refreshDailyBrief() = IncomingPushActionRefreshDailyBrief;

  factory IncomingPushAction.navigateTo(String path) = IncomingPushActionNavigateTo;

  factory IncomingPushAction.briefEntrySeenByUser(int badgeCount) = IncomingPushActionBriefEntrySeenByUser;

  factory IncomingPushAction.briefEntriesUpdated(int badgeCount) = IncomingPushActionBriefEntriesUpdated;

  factory IncomingPushAction.newBriefPublished(int badgeCount) = IncomingPushActionNewBriefPublished;

  factory IncomingPushAction.unknown(String type) = IncomingPushActionUnknown;
}
