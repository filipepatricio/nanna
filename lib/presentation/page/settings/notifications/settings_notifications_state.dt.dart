import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_notifications_state.dt.freezed.dart';

@Freezed(toJson: false)
class SettingsNotificationsState with _$SettingsNotificationsState {
  @Implements<BuildState>()
  factory SettingsNotificationsState.loading() = _SettingsNotificationsStateLoading;

  @Implements<BuildState>()
  factory SettingsNotificationsState.noPermission(List<NotificationPreferencesGroup> groups) =
      _SettingsNotificationsStateNoPermission;

  @Implements<BuildState>()
  factory SettingsNotificationsState.notificationSettingsLoaded(List<NotificationPreferencesGroup> groups) =
      _SettingsNotificationsStateLoaded;

  @Implements<BuildState>()
  factory SettingsNotificationsState.error() = _SettingsNotificationsStateError;

  @Implements<BuildState>()
  factory SettingsNotificationsState.offline() = _SettingsNotificationsStateOffline;

  @Implements<BuildState>()
  factory SettingsNotificationsState.guest() = _SettingsNotificationsStateGuest;
}
