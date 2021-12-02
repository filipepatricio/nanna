import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetTutorialFlowUseCase {
  final TutorialStore _tutorialStore;

  ResetTutorialFlowUseCase(this._tutorialStore);

  Future<void> call() => _tutorialStore.resetTutorial();
}
