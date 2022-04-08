import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationPreferencesUseCase {
  final PushNotificationRepository _pushNotificationRepository;

  GetNotificationPreferencesUseCase(this._pushNotificationRepository);

  Future<NotificationPreferences> call() => _pushNotificationRepository.getNotificationPreferences();
}
