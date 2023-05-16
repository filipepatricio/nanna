import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearGuestModeUseCase {
  const ClearGuestModeUseCase(this._userStore);

  final UserStore _userStore;

  Future<void> call() async {
    try {
      return await _userStore.clearGuestMode();
    } catch (e, s) {
      Fimber.e('Clearing guest mode failed', ex: e, stacktrace: s);
      return;
    }
  }
}
