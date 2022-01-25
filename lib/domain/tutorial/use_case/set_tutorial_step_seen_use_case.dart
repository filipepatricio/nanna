import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetTutorialStepSeenUseCase {
  final TutorialStore _tutorialStore;

  SetTutorialStepSeenUseCase(this._tutorialStore);

  Future<void> call(TutorialStep tutorialStep) => _tutorialStore.setTutorialStepSeen(tutorialStep);
}
