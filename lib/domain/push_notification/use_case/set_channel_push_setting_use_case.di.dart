import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetChannelPushSettingUseCase {
  final PushNotificationRepository _pushNotificationRepository;

  SetChannelPushSettingUseCase(this._pushNotificationRepository);

  Future<NotificationChannel> call(NotificationChannel channel, bool enabled) async {
    return _pushNotificationRepository.setNotificationChannel(
      channel.id,
      enabled,
      null,
    );
  }
}
