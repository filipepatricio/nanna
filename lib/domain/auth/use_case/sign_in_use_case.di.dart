import 'package:better_informed_mobile/domain/analytics/use_case/identify_analytics_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInUseCase {
  SignInUseCase(
    this._authRepository,
    this._authStore,
    this._userStore,
    this._getUserUseCase,
    this._initializePurchasesUseCase,
    this._identifyAnalyticsUserUseCase,
  );

  final AuthRepository _authRepository;
  final AuthStore _authStore;
  final UserStore _userStore;
  final GetUserUseCase _getUserUseCase;
  final InitializePurchasesUseCase _initializePurchasesUseCase;
  final IdentifyAnalyticsUserUseCase _identifyAnalyticsUserUseCase;

  Future<void> withApple() async {
    final authResult = await _authRepository.signInWithApple();
    await _finalize(authResult);
  }

  Future<void> withGoogle() async {
    final authResult = await _authRepository.signInWithGoogle();
    await _finalize(authResult);
  }

  Future<void> withLinkeding() async {
    final authResult = await _authRepository.signInWithLinkedin();
    await _finalize(authResult);
  }

  Future<void> withMagicLink(String token) async {
    final authResult = await _authRepository.signInWithMagicLinkToken(token);
    await _finalize(authResult);
  }

  Future<void> _finalize(AuthResult authResult) async {
    await _authStore.save(authResult.authToken);
    await _userStore.setCurrentUserUuid(authResult.userUuid);

    await _initializePurchasesUseCase();
    await _identifyAnalyticsUserUseCase(authResult.method);

    _getUserUseCase().ignore();
  }
}
