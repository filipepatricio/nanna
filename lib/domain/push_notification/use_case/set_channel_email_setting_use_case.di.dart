import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetChannelEmailSettingUseCase {
  SetChannelEmailSettingUseCase(this._pushNotificationRepository);
  final PushNotificationRepository _pushNotificationRepository;

  Future<NotificationChannel> call(NotificationChannel channel, bool enabled) async {
    return _pushNotificationRepository.setNotificationChannel(
      channel.id,
      null,
      enabled,
    );
  }
}
