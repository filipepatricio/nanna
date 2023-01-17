import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/general/article_read_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOutUseCase {
  SignOutUseCase(
    this._authStore,
    this._analyticsRepository,
    this._pushNotificationStore,
    this._pushNotificationRepository,
    this._refreshTokenServiceCache,
    this._userStore,
    this._purchasesRepository,
    this._articleRepository,
    this._getIt,
  );
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;
  final PushNotificationStore _pushNotificationStore;
  final PushNotificationRepository _pushNotificationRepository;
  final RefreshTokenServiceCache _refreshTokenServiceCache;
  final UserStore _userStore;
  final PurchasesRepository _purchasesRepository;
  final ArticleRepository _articleRepository;
  final GetIt _getIt;

  Future<void> call() async {
    _refreshTokenServiceCache.clear();
    _pushNotificationRepository.dispose();
    _purchasesRepository.dispose();
    _articleRepository.dispose();

    await _pushNotificationStore.clear();
    await _authStore.delete();
    await _userStore.clearCurrentUserUuid();
    await _analyticsRepository.logout();

    _getIt.resetLazySingleton<ArticleReadStateNotifier>();
  }
}
