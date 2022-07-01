import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetTutorialStepSeenUseCase {
  SetTutorialStepSeenUseCase(
    this._tutorialStore,
    this._userStore,
  );
  final TutorialStore _tutorialStore;
  final UserStore _userStore;

  Future<void> call(TutorialStep tutorialStep) async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _tutorialStore.setUserTutorialStepSeen(currentUserUuid, tutorialStep);
  }
}
