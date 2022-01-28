import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetTutorialFlowUseCase {
  final TutorialStore _tutorialStore;
  final UserStore _userStore;

  ResetTutorialFlowUseCase(
    this._tutorialStore,
    this._userStore,
  );

  Future<void> call() async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _tutorialStore.resetUserTutorial(currentUserUuid);
  }
}
