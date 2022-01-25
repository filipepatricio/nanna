import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'onboardingBox';
const _onboardingKey = 'onboardingKey';

@LazySingleton(as: OnboardingDatabase, env: liveEnvs)
class OnboardingHiveDatabase implements OnboardingDatabase {
  @override
  Future<bool> isOnboardingSeen() async {
    final box = await Hive.openBox(_hiveBoxName);
    final onboardingStepValue = box.get(_onboardingKey) as bool?;
    return onboardingStepValue ?? false;
  }

  @override
  Future<void> setOnboardingSeen() async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.put(_onboardingKey, true);
  }

  @override
  Future<void> resetOnboarding() async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.clear();
  }
}
