import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_setting_switch_state.dt.freezed.dart';

@freezed
class NotificationSettingSwitchState with _$NotificationSettingSwitchState {
  @Implements<BuildState>()
  factory NotificationSettingSwitchState.notInitialized() = _NotificationSettingSwitchStateNotInitialized;

  @Implements<BuildState>()
  factory NotificationSettingSwitchState.processing(String name, bool value) =
      _NotificationSettingSwitchStateProcessing;

  @Implements<BuildState>()
  factory NotificationSettingSwitchState.idle(String name, bool value) = _NotificationSettingSwitchStateIdle;

  factory NotificationSettingSwitchState.generalError() = _NotificationSettingSwitchStateGeneralError;
}
