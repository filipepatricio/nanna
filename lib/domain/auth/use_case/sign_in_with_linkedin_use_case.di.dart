import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithLinkedinUseCase {
  SignInWithLinkedinUseCase(
    this._authRepository,
    this._authStore,
    this._analyticsRepository,
    this._userStore,
    this._purchasesRepository,
  );

  final AuthRepository _authRepository;
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;
  final UserStore _userStore;
  final PurchasesRepository _purchasesRepository;

  Future<void> call() async {
    final authResult = await _authRepository.signInWithLinkedin();

    await _authStore.save(authResult.authToken);
    await _userStore.setCurrentUserUuid(authResult.userUuid);

    await _purchasesRepository.initialize(authResult.userUuid);
    await _analyticsRepository.identify(
      authResult.userUuid,
      authResult.method,
    );
  }
}
