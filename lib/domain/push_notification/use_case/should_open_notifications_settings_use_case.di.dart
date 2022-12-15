import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShouldOpenNotificationsSettingsUseCase {
  ShouldOpenNotificationsSettingsUseCase(this._pushNotificationRepository);
  final PushNotificationRepository _pushNotificationRepository;

  Future<bool> call() => _pushNotificationRepository.shouldOpenNotificationsSettings();
}
