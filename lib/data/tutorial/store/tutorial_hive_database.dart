import 'package:better_informed_mobile/data/tutorial/store/tutorial_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_steps_extension.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'tutorialBox';

@LazySingleton(as: TutorialDatabase, env: liveEnvs)
class TutorialHiveDatabase implements TutorialDatabase {
  @override
  Future<bool> isTutorialStepSeen(TutorialStep tutorialStep) async {
    final box = await Hive.openBox(_hiveBoxName);
    final tutorialStepValue = box.get(tutorialStep.key) as bool?;
    return tutorialStepValue ?? false;
  }

  @override
  Future<void> setTutorialStepSeen(TutorialStep tutorialStep) async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.put(tutorialStep.key, true);
  }

  @override
  Future<void> resetTutorial() async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.clear();
  }
}
