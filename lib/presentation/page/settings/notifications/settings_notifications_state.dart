import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_notifications_state.freezed.dart';

@freezed
abstract class SettingsNotificationsState with _$SettingsNotificationsState {
  const factory SettingsNotificationsState.loading() = SettingsNotificationsStateLoading;

  const factory SettingsNotificationsState.notificationSettingsLoaded(SettingsNotificationsData data) =
      SettingsNotificationsStateLoaded;
}
