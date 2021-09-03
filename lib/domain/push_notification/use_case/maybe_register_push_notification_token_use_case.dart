import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

const daysToExpire = 7;

@injectable
class MaybeRegisterPushNotificationTokenUseCase {
  final PushNotificationStore _pushNotificationStore;
  final PushNotificationRepository _pushNotificationRepository;

  MaybeRegisterPushNotificationTokenUseCase(
    this._pushNotificationStore,
    this._pushNotificationRepository,
  );

  Future<void> call() async {
    final storedToken = await _pushNotificationStore.load();

    if (storedToken == null || _isExpired(storedToken.updatedAt) || await _hasChanged(storedToken.token)) {
      final registeredToken = await _pushNotificationRepository.registerToken();
      await _pushNotificationStore.save(registeredToken);
    }
  }

  bool _isExpired(DateTime updatedAt) {
    final now = clock.now();
    final expirationDate = updatedAt.add(const Duration(days: daysToExpire));

    return !now.isBefore(expirationDate);
  }

  Future<bool> _hasChanged(String storedToken) async {
    final currentToken = await _pushNotificationRepository.getCurrentToken();
    return storedToken != currentToken;
  }
}
