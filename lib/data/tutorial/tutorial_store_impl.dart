import 'package:better_informed_mobile/data/tutorial/store/tutorial_database.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TutorialStore)
class TutorialStoreImpl extends TutorialStore {
  final TutorialDatabase _database;

  TutorialStoreImpl(this._database);

  @override
  Future<bool> isTutorialStepSeen(TutorialStep tutorialStep) async {
    return await _database.isTutorialStepSeen(tutorialStep);
  }

  @override
  Future<void> setTutorialStepSeen(TutorialStep tutorialStep) async {
    await _database.setTutorialStepSeen(tutorialStep);
  }

  @override
  Future<void> resetTutorial() => _database.resetTutorial();
}
