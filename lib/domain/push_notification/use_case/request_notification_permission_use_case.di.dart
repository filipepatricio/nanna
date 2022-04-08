import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestNotificationPermissionUseCase {
  final PushNotificationRepository _pushNotificationRepository;

  RequestNotificationPermissionUseCase(this._pushNotificationRepository);

  Future<bool> call() => _pushNotificationRepository.requestPermission();
}
