import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/has_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/set_channel_email_setting_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/set_channel_push_setting_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationSettingSwitchCubit extends Cubit<NotificationSettingSwitchState> {
  NotificationSettingSwitchCubit(
    this._setChannelPushSettingUseCase,
    this._setChannelEmailSettingUseCase,
    this._hasNotificationPermissionUseCase,
  ) : super(NotificationSettingSwitchState.notInitialized());

  final SetChannelPushSettingUseCase _setChannelPushSettingUseCase;
  final SetChannelEmailSettingUseCase _setChannelEmailSettingUseCase;
  final HasNotificationPermissionUseCase _hasNotificationPermissionUseCase;

  late NotificationType _notificationType;
  late NotificationChannel _channel;
  late bool _requiresPermission;

  Future<void> initialize(
    NotificationChannel channel,
    NotificationType notificationType,
    bool requiresPermission,
  ) async {
    _notificationType = notificationType;
    _channel = channel;
    _requiresPermission = requiresPermission;
    emit(NotificationSettingSwitchState.idle(_channel.name, await _getValue()));
  }

  Future<void> changeSetting(bool value) async {
    emit(NotificationSettingSwitchState.processing(_channel.name, await _getValue()));

    try {
      _channel = await _updateChannel(value);
    } catch (e, s) {
      Fimber.e('Setting notification channel failed', ex: e, stacktrace: s);
      emit(NotificationSettingSwitchState.generalError());
    }

    emit(NotificationSettingSwitchState.idle(_channel.name, await _getValue()));
  }

  Future<bool> _getValue() async {
    switch (_notificationType) {
      case NotificationType.push:
        return _channel.pushEnabled && (!_requiresPermission || await _hasNotificationPermissionUseCase());
      case NotificationType.email:
        return _channel.emailEnabled;
    }
  }

  Future<NotificationChannel> _updateChannel(bool value) async {
    switch (_notificationType) {
      case NotificationType.push:
        if (!_requiresPermission || await _hasNotificationPermissionUseCase()) {
          return _setChannelPushSettingUseCase(_channel, value);
        }

        emit(NotificationSettingSwitchState.noPermissionError());
        return _channel;
      case NotificationType.email:
        return _setChannelEmailSettingUseCase(_channel, value);
    }
  }
}
