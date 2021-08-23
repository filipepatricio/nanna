import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithMagicLinkTokenUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  SignInWithMagicLinkTokenUseCase(
    this._authRepository,
    this._authStore,
  );

  Future<void> call(String token) async {
    final tokens = await _authRepository.signInWithMagicLinkToken(token);
    await _authStore.save(tokens);
  }
}
