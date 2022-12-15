import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OpenNotificationsSettingsUseCase {
  OpenNotificationsSettingsUseCase(this._pushNotificationRepository);
  final PushNotificationRepository _pushNotificationRepository;

  Future<void> call() => _pushNotificationRepository.openNotificationsSettings();
}
