import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';

abstract class TutorialDatabase {
  Future<bool> isTutorialStepSeen(String userUuid, TutorialStep tutorialStep);

  Future<void> setTutorialStepSeen(String userUuid, TutorialStep tutorialStep);

  Future<void> resetTutorial(String userUuid);
}
