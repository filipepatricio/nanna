import 'package:better_informed_mobile/domain/tutorial/data/tutorial_steps.dart';

abstract class TutorialDatabase {
  Future<bool> isTutorialStepSeen(TutorialStep tutorialStep);
  Future<void> setTutorialStepSeen(TutorialStep tutorialStep);
  Future<void> resetTutorial();
}
