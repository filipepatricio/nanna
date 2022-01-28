import 'package:better_informed_mobile/data/tutorial/store/tutorial_database.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TutorialStore)
class TutorialStoreImpl extends TutorialStore {
  final TutorialDatabase _database;

  TutorialStoreImpl(this._database);

  @override
  Future<bool> isUserTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    return await _database.isTutorialStepSeen(userUuid, tutorialStep);
  }

  @override
  Future<void> setUserTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    await _database.setTutorialStepSeen(userUuid, tutorialStep);
  }

  @override
  Future<void> resetUserTutorial(String userUuid) => _database.resetTutorial(userUuid);
}
