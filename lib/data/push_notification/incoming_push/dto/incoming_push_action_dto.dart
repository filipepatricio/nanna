import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/navigate_action_args_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_push_action_dto.freezed.dart';

part 'incoming_push_action_dto.g.dart';

@Freezed(
  unionKey: 'type',
  fallbackUnion: 'unknown',
)
class IncomingPushActionDTO with _$IncomingPushActionDTO {
  @FreezedUnionValue('refresh_daily_brief')
  factory IncomingPushActionDTO.refreshDailyBrief() = _IncomingPushActionDTORefreshDailyBrief;

  @FreezedUnionValue('navigate_to')
  factory IncomingPushActionDTO.navigateTo(NavigateActionArgsDTO args) = _IncomingPushActionDTONavigateTo;

  @FreezedUnionValue('unknown')
  factory IncomingPushActionDTO.unknown(String type) = _IncomingPushActionDTOUnknown;

  factory IncomingPushActionDTO.fromJson(Map<String, dynamic> json) => _$IncomingPushActionDTOFromJson(json);
}
