import 'package:better_informed_mobile/data/tutorial/store/tutorial_database.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TutorialStore)
class TutorialStoreImpl extends TutorialStore {
  TutorialStoreImpl(this._database);
  final TutorialDatabase _database;

  @override
  Future<bool> isUserTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    return await _database.isTutorialStepSeen(userUuid, tutorialStep);
  }

  @override
  Future<void> setUserTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    await _database.setTutorialStepSeen(userUuid, tutorialStep);
  }

  @override
  Future<void> resetUserTutorial(String userUuid) async => await _database.resetTutorial(userUuid);
}
