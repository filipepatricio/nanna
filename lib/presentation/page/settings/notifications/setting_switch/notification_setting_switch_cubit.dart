import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/set_channel_push_setting_use_case.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationSettingSwitchCubit extends Cubit<NotificationSettingSwitchState> {
  final SetChannelPushSettingUseCase _setChannelPushSettingUseCase;

  late NotificationChannel _channel;

  NotificationSettingSwitchCubit(
    this._setChannelPushSettingUseCase,
  ) : super(NotificationSettingSwitchState.notInitialized());

  void initialize(NotificationChannel channel) {
    _channel = channel;
    emit(NotificationSettingSwitchState.idle(_channel.name, _channel.pushEnabled));
  }

  Future<void> changeSetting(bool value) async {
    emit(NotificationSettingSwitchState.processing(_channel.name, _channel.pushEnabled));

    try {
      _channel = await _setChannelPushSettingUseCase(_channel, value);
    } catch (e, s) {
      Fimber.e('Setting notification channel failed', ex: e, stacktrace: s);
    }

    emit(NotificationSettingSwitchState.idle(_channel.name, _channel.pushEnabled));
  }
}
