import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_notifications_state.freezed.dart';

@freezed
class SettingsNotificationsState with _$SettingsNotificationsState {
  @Implements(BuildState)
  factory SettingsNotificationsState.loading() = SettingsNotificationsStateLoading;

  @Implements(BuildState)
  factory SettingsNotificationsState.notificationSettingsLoaded(List<NotificationPreferencesGroup> groups) =
      SettingsNotificationsStateLoaded;
}
