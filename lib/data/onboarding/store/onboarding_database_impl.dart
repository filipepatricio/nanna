import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'onboardingBox';
const _onboardingKey = 'onboardingKey';

@LazySingleton(as: OnboardingDatabase, env: liveEnvs)
class OnboardingDatabaseImpl implements OnboardingDatabase {
  final UserStore _userStore;

  OnboardingDatabaseImpl(this._userStore);

  @override
  Future<bool> isOnboardingSeen() async {
    final box = await _userStore.openBox(_hiveBoxName);
    final onboardingValue = box.get(_onboardingKey) as bool?;
    return onboardingValue ?? false;
  }

  @override
  Future<void> setOnboardingSeen() async {
    final box = await _userStore.openBox(_hiveBoxName);
    await box.put(_onboardingKey, true);
  }

  @override
  Future<void> resetOnboarding() async {
    final box = await _userStore.openBox(_hiveBoxName);
    await box.clear();
  }
}
