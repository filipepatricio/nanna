import 'package:better_informed_mobile/data/subscription/store/subscription_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SubscriptionDatabase, env: mockEnvs)
class SubscriptionMockDatabase implements SubscriptionDatabase {
  @override
  Future<bool> isOnboardingPaywallSeen(String userUuid) async {
    return true;
  }

  @override
  Future<void> resetUserSubscriptionStore(String userUuid) async {
    return;
  }

  @override
  Future<void> setOnboardingPaywallSeen(String userUuid) async {
    return;
  }
}
