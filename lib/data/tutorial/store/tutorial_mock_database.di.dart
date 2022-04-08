import 'package:better_informed_mobile/data/tutorial/store/tutorial_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TutorialDatabase, env: mockEnvs)
class TutorialMockDatabase implements TutorialDatabase {
  @override
  Future<bool> isTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    return true;
  }

  @override
  Future<void> setTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {}

  @override
  Future<void> resetTutorial(String userUuid) async {}
}
