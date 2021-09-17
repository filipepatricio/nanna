import 'package:better_informed_mobile/domain/push_notification/use_case/get_notification_preferences_use_case.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsNotificationCubit extends Cubit<SettingsNotificationsState> {
  final GetNotificationPreferencesUseCase _getNotificationPreferencesUseCase;

  SettingsNotificationCubit(
    this._getNotificationPreferencesUseCase,
  ) : super(SettingsNotificationsState.loading());

  Future<void> initialize() async {
    emit(SettingsNotificationsState.loading());

    try {
      final preferences = await _getNotificationPreferencesUseCase();
      emit(SettingsNotificationsState.notificationSettingsLoaded(preferences.groups));
    } catch (e, s) {
      Fimber.e('Getting notification preferences failed', ex: e, stacktrace: s);
    }
  }
}
