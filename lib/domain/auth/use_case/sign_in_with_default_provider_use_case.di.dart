import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithDefaultProviderUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;
  final UserStore _userStore;

  SignInWithDefaultProviderUseCase(
    this._authRepository,
    this._authStore,
    this._analyticsRepository,
    this._featuresFlagsRepository,
    this._userStore,
  );

  Future<void> call() async {
    final authResult = await _authRepository.signInWithDefaultProvider();
    final user = authResult.user;

    await _authStore.save(authResult.authToken);
    await _userStore.setCurrentUserUuid(authResult.user.uuid);

    await _analyticsRepository.login(
      authResult.user.uuid,
      authResult.method,
    );

    await _featuresFlagsRepository.initialize(user.uuid, user.email);
  }
}
