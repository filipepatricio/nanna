import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithDefaultProviderUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  SignInWithDefaultProviderUseCase(
    this._authRepository,
    this._authStore,
  );

  Future<void> call() async {
    final authResult = await _authRepository.signInWithDefaultProvider();
    await _authStore.save(authResult);
  }
}
