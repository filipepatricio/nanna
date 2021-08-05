import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dart';
import 'package:bloc/bloc.dart';

class SettingsNotificationCubit extends Cubit<SettingsNotificationsState> {
  SettingsNotificationCubit() : super(const SettingsNotificationsState.loading()) {
    //TODO: REPLACE WITH USER SETTINGS WHEN AVAILABLE
    emit(
      SettingsNotificationsState.notificationSettingsLoaded(
        SettingsNotificationsData(dailyBrief: false, incomingNewTopic: true, newFeatures: false),
      ),
    );
  }

  Future<void> onDailyBriefChange(bool value) async {
    //TODO: SAVE USER PREFERENCES
  }

  Future<void> onIncomingNewTopicChange(bool value) async {
    //TODO: SAVE USER PREFERENCES
  }

  Future<void> onNewFeaturesChange(bool value) async {
    //TODO: SAVE USER PREFERENCES
  }
}
