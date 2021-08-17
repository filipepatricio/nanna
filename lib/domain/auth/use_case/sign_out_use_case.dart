import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOutUseCase {
  final AuthStore _authStore;

  SignOutUseCase(this._authStore);

  Future<void> call() async {
    await _authStore.delete();
  }
}
