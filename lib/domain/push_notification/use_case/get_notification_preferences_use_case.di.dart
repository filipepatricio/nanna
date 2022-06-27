import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationPreferencesUseCase {
  GetNotificationPreferencesUseCase(this._pushNotificationRepository);
  final PushNotificationRepository _pushNotificationRepository;

  Future<NotificationPreferences> call() => _pushNotificationRepository.getNotificationPreferences();
}
