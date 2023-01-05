import 'package:better_informed_mobile/data/subscription/store/subscription_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'subscriptionBox';
const _onboardingPaywallKey = 'onboardingPaywall';

@LazySingleton(as: SubscriptionDatabase, env: defaultEnvs)
class SubscriptionHiveDatabase implements SubscriptionDatabase {
  Future<Box<dynamic>> _openUserBox(String userUuid, String hiveBoxName) async {
    final box = await Hive.openBox('${userUuid}_$hiveBoxName');
    return box;
  }

  @override
  Future<bool> isOnboardingPaywallSeen(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    final tutorialStepValue = box.get(_onboardingPaywallKey) as bool?;
    return tutorialStepValue ?? false;
  }

  @override
  Future<void> setOnboardingPaywallSeen(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.put(_onboardingPaywallKey, true);
  }

  @override
  Future<void> resetUserSubscriptionStore(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.clear();
  }
}
