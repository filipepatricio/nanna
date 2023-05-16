import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetGuestModeUseCase {
  const SetGuestModeUseCase(this._userStore);

  final UserStore _userStore;

  Future<void> call() async {
    try {
      return await _userStore.setGuestMode();
    } catch (e, s) {
      Fimber.e('Setting guest mode failed', ex: e, stacktrace: s);
      return;
    }
  }
}
