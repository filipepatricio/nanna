import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithDefaultProviderUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;
  final UserStore _userStore;

  SignInWithDefaultProviderUseCase(
    this._authRepository,
    this._authStore,
    this._analyticsRepository,
    this._userStore,
  );

  Future<void> call() async {
    final authResult = await _authRepository.signInWithDefaultProvider();
    await _authStore.save(authResult.authToken);
    await _userStore.setLoggedInUserUuid(authResult.userUuid);

    await _analyticsRepository.login(
      authResult.userUuid,
      authResult.method,
    );
  }
}
