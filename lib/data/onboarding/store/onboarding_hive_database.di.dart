import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'onboardingBox';
const _onboardingKey = 'onboardingKey';

@LazySingleton(as: OnboardingDatabase, env: liveEnvs)
class OnboardingHiveDatabase implements OnboardingDatabase {
  Future<Box<dynamic>> _openUserBox(String userUuid, String hiveBoxName) async {
    final box = await Hive.openBox('${userUuid}_$hiveBoxName');
    return box;
  }

  @override
  Future<bool> isOnboardingSeen(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    final onboardingValue = box.get(_onboardingKey) as bool?;
    return onboardingValue ?? false;
  }

  @override
  Future<void> setOnboardingVersion(String userUuid, int version) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.put(_onboardingKey, version);
  }

  @override
  Future<void> resetOnboarding(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.clear();
  }

  @override
  Future<int?> getOnboardingVersion(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    final onboardingValue = box.get(_onboardingKey);
    if (onboardingValue is int) {
      return onboardingValue;
    } else {
      return null;
    }
  }
}
