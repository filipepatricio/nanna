import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/get_notification_preferences_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/has_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/open_notifications_settings_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/should_open_notifications_settings_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsNotificationCubit extends Cubit<SettingsNotificationsState> {
  SettingsNotificationCubit(
    this._getNotificationPreferencesUseCase,
    this._hasNotificationPermissionUseCase,
    this._requestNotificationPermissionUseCase,
    this._shouldOpenNotificationsSettingsUseCase,
    this._openNotificationsSettingsUseCase,
    this._isSignedInUseCase,
  ) : super(SettingsNotificationsState.loading());

  final GetNotificationPreferencesUseCase _getNotificationPreferencesUseCase;
  final HasNotificationPermissionUseCase _hasNotificationPermissionUseCase;
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;
  final ShouldOpenNotificationsSettingsUseCase _shouldOpenNotificationsSettingsUseCase;
  final OpenNotificationsSettingsUseCase _openNotificationsSettingsUseCase;
  final IsSignedInUseCase _isSignedInUseCase;

  Future<void> initialize() async {
    emit(SettingsNotificationsState.loading());

    if (!await _isSignedInUseCase()) {
      emit(SettingsNotificationsState.guest());
      return;
    }

    try {
      final hasPermission = await _hasNotificationPermissionUseCase();
      await _getNotificationPreferences(hasPermission);
    } on NoInternetConnectionException {
      emit(SettingsNotificationsState.offline());
    } catch (e, s) {
      emit(SettingsNotificationsState.error());
      Fimber.e('Getting notification preferences failed', ex: e, stacktrace: s);
    }
  }

  Future<void> requestPermission() async {
    final hasGivenPermission = await _requestNotificationPermissionUseCase();
    if (hasGivenPermission) {
      await _getNotificationPreferences(hasGivenPermission);
      return;
    }

    final shouldOpenSettings = await _shouldOpenNotificationsSettingsUseCase();
    if (shouldOpenSettings) {
      await _openNotificationsSettingsUseCase();
      return;
    }
  }

  Future<void> _getNotificationPreferences(bool hasNotificationsPermission) async {
    final preferences = await _getNotificationPreferencesUseCase();
    if (hasNotificationsPermission) {
      emit(SettingsNotificationsState.notificationSettingsLoaded(preferences.groups));
    } else {
      emit(SettingsNotificationsState.noPermission(preferences.groups));
    }
  }
}
