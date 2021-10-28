import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithDefaultProviderUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;

  SignInWithDefaultProviderUseCase(
    this._authRepository,
    this._authStore,
    this._analyticsRepository,
  );

  Future<void> call() async {
    final authResult = await _authRepository.signInWithDefaultProvider();
    await _authStore.save(authResult.authToken);

    await _analyticsRepository.login(
      authResult.userId.toString(),
      authResult.method,
    );
  }
}
