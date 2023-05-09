import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/subscription_local_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SubscriptionLocalRepository, env: mockEnvs)
class SubscriptionLocalRepositoryMock implements SubscriptionLocalRepository {
  @override
  Future<void> clear(String userUuid) async {}

  @override
  Future<ActiveSubscription?> loadActiveSubscription() async {}

  @override
  Future<void> saveActiveSubscription(ActiveSubscription activeSubscription) async {}
}
