import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOutUseCase {
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;
  final PushNotificationStore _pushNotificationStore;
  final PushNotificationRepository _pushNotificationRepository;
  final RefreshTokenServiceCache _refreshTokenServiceCache;
  final UserStore _userStore;

  SignOutUseCase(
    this._authStore,
    this._analyticsRepository,
    this._pushNotificationStore,
    this._pushNotificationRepository,
    this._refreshTokenServiceCache,
    this._userStore,
  );

  Future<void> call() async {
    _refreshTokenServiceCache.clear();
    _pushNotificationRepository.dispose();

    await _pushNotificationStore.clear();
    await _authStore.delete();
    await _userStore.clearCurrentUserUuid();
    await _analyticsRepository.logout();
  }
}