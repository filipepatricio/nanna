import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/navigate_action_args_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_push_action_dto.dt.freezed.dart';
part 'incoming_push_action_dto.dt.g.dart';

@Freezed(unionKey: 'type', fallbackUnion: unknownKey, toJson: false)
class IncomingPushActionDTO with _$IncomingPushActionDTO {
  @FreezedUnionValue('refresh_daily_brief')
  factory IncomingPushActionDTO.refreshDailyBrief() = _IncomingPushActionDTORefreshDailyBrief;

  @FreezedUnionValue('navigate_to')
  factory IncomingPushActionDTO.navigateTo(NavigateActionArgsDTO args) = _IncomingPushActionDTONavigateTo;

  @FreezedUnionValue(unknownKey)
  factory IncomingPushActionDTO.unknown(String type) = _IncomingPushActionDTOUnknown;

  factory IncomingPushActionDTO.fromJson(Map<String, dynamic> json) => _$IncomingPushActionDTOFromJson(json);
}
