import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsGuestModeUseCase {
  const IsGuestModeUseCase(this._userStore);

  final UserStore _userStore;

  Future<bool> call() async {
    try {
      return await _userStore.isGuestMode();
    } catch (e, s) {
      Fimber.e('Checking if it is guest mode faile', ex: e, stacktrace: s);
      return false;
    }
  }
}
