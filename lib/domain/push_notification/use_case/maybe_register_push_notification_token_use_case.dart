import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
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

    if (storedToken == null || _isExpired(storedToken) || await _hasChanged(storedToken)) {
      final registeredToken = await _pushNotificationRepository.registerToken();
      await _pushNotificationStore.save(registeredToken);
    }
  }

  bool _isExpired(RegisteredPushToken registeredPushToken) {
    final now = clock.now();
    final expirationDate = registeredPushToken.updatedAt.add(const Duration(days: daysToExpire));

    return !now.isBefore(expirationDate);
  }

  Future<bool> _hasChanged(RegisteredPushToken registeredPushToken) async {
    final currentToken = await _pushNotificationRepository.getCurrentToken();
    return registeredPushToken.token != currentToken;
  }
}
