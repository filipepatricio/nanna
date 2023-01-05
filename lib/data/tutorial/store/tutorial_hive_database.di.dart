import 'package:better_informed_mobile/data/tutorial/store/tutorial_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_steps_extension.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'tutorialBox';

@LazySingleton(as: TutorialDatabase, env: defaultEnvs)
class TutorialHiveDatabase implements TutorialDatabase {
  Future<Box<dynamic>> _openUserBox(String userUuid, String hiveBoxName) async {
    final box = await Hive.openBox('${userUuid}_$hiveBoxName');
    return box;
  }

  @override
  Future<bool> isTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    final tutorialStepValue = box.get(tutorialStep.key) as bool?;
    return tutorialStepValue ?? false;
  }

  @override
  Future<void> setTutorialStepSeen(String userUuid, TutorialStep tutorialStep) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.put(tutorialStep.key, true);
  }

  @override
  Future<void> resetTutorial(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.clear();
  }
}
