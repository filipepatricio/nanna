import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithMagicLinkTokenUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;

  SignInWithMagicLinkTokenUseCase(
    this._authRepository,
    this._authStore,
    this._analyticsRepository,
  );

  Future<void> call(String token) async {
    final authResult = await _authRepository.signInWithMagicLinkToken(token);
    await _authStore.save(authResult.authToken);

    await _analyticsRepository.login(
      authResult.userId.toString(),
      authResult.method,
    );
  }
}
