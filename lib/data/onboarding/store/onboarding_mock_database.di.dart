import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingDatabase, env: mockEnvs)
class OnboardingMockDatabase implements OnboardingDatabase {
  @override
  Future<bool> isOnboardingSeen(String userUuid) async {
    return true;
  }

  @override
  Future<void> setOnboardingSeen(String userUuid) async {}

  @override
  Future<void> resetOnboarding(String userUuid) async {}
}