import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetChannelEmailSettingUseCase {
  final PushNotificationRepository _pushNotificationRepository;

  SetChannelEmailSettingUseCase(this._pushNotificationRepository);

  Future<NotificationChannel> call(NotificationChannel channel, bool enabled) async {
    return _pushNotificationRepository.setNotificationChannel(
      channel.id,
      null,
      enabled,
    );
  }
}
