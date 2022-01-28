import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsTutorialStepSeenUseCase {
  final TutorialStore _tutorialStore;
  final UserStore _userStore;

  IsTutorialStepSeenUseCase(
    this._tutorialStore,
    this._userStore,
  );

  Future<bool> call(TutorialStep tutorialStep) async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _tutorialStore.isUserTutorialStepSeen(currentUserUuid, tutorialStep);
  }
}
