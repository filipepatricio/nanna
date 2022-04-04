import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/set_channel_email_setting_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/set_channel_push_setting_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationSettingSwitchCubit extends Cubit<NotificationSettingSwitchState> {
  final SetChannelPushSettingUseCase _setChannelPushSettingUseCase;
  final SetChannelEmailSettingUseCase _setChannelEmailSettingUseCase;

  late NotificationType _notificationType;
  late NotificationChannel _channel;

  NotificationSettingSwitchCubit(
    this._setChannelPushSettingUseCase,
    this._setChannelEmailSettingUseCase,
  ) : super(NotificationSettingSwitchState.notInitialized());

  void initialize(NotificationChannel channel, NotificationType notificationType) {
    _notificationType = notificationType;
    _channel = channel;
    emit(NotificationSettingSwitchState.idle(_channel.name, _getValue()));
  }

  Future<void> changeSetting(bool value) async {
    emit(NotificationSettingSwitchState.processing(_channel.name, _getValue()));

    try {
      _channel = await _updateChannel(value);
    } catch (e, s) {
      Fimber.e('Setting notification channel failed', ex: e, stacktrace: s);
      emit(NotificationSettingSwitchState.generalError());
    }

    emit(NotificationSettingSwitchState.idle(_channel.name, _getValue()));
  }

  bool _getValue() {
    switch (_notificationType) {
      case NotificationType.push:
        return _channel.pushEnabled;
      case NotificationType.email:
        return _channel.emailEnabled;
    }
  }

  Future<NotificationChannel> _updateChannel(bool value) async {
    switch (_notificationType) {
      case NotificationType.push:
        return _setChannelPushSettingUseCase(_channel, value);
      case NotificationType.email:
        return _setChannelEmailSettingUseCase(_channel, value);
    }
  }
}
