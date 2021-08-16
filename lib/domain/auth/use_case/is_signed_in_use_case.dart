import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsSignedInUseCase {
  final AuthStore _authStore;

  IsSignedInUseCase(this._authStore);

  Future<bool> call() async {
    try {
      final token = await _authStore.read();
      return token != null;
    } catch (e, s) {
      Fimber.e('Checking if user is signed failed', ex: e, stacktrace: s);
      return false;
    }
  }
}
