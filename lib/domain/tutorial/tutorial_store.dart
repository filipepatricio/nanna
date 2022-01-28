import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';

abstract class TutorialStore {
  Future<bool> isUserTutorialStepSeen(String userUuid, TutorialStep tutorialStep);

  Future<void> setUserTutorialStepSeen(String userUuid, TutorialStep tutorialStep);

  Future<void> resetUserTutorial(String userUuid);
}
