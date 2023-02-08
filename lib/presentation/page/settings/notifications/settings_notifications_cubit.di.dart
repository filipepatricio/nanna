import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/get_notification_preferences_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/has_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/open_notifications_settings_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/should_open_notifications_settings_use_case.di.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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
  ) : super(SettingsNotificationsState.loading());

  final GetNotificationPreferencesUseCase _getNotificationPreferencesUseCase;
  final HasNotificationPermissionUseCase _hasNotificationPermissionUseCase;
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;
  final ShouldOpenNotificationsSettingsUseCase _shouldOpenNotificationsSettingsUseCase;
  final OpenNotificationsSettingsUseCase _openNotificationsSettingsUseCase;

  Future<void> initialize() async {
    emit(SettingsNotificationsState.loading());

    try {
      final hasPermission = await _hasNotificationPermissionUseCase();
      await _getNotificationPreferences(hasPermission);
    } on NoInternetConnectionException {
      emit(
        SettingsNotificationsState.error(
          LocaleKeys.noConnection_error_title.tr(),
          LocaleKeys.noConnection_error_message.tr(),
        ),
      );
    } catch (e, s) {
      emit(
        SettingsNotificationsState.error(
          LocaleKeys.common_error_title.tr(),
          LocaleKeys.common_error_body.tr(),
        ),
      );
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
