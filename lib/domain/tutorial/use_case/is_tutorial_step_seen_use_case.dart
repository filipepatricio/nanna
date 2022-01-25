import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsTutorialStepSeenUseCase {
  final TutorialStore _tutorialStore;

  IsTutorialStepSeenUseCase(this._tutorialStore);

  Future<bool> call(TutorialStep tutorialStep) => _tutorialStore.isTutorialStepSeen(tutorialStep);
}
