import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingDatabase, env: mockEnvs)
class OnboardingMockDatabase implements OnboardingDatabase {
  @override
  Future<void> setOnboardingVersion(String userUuid, int version) async {}

  @override
  Future<void> resetOnboarding(String userUuid) async {}

  @override
  Future<int?> getOnboardingVersion(String userUuid) async {
    return 1;
  }
}
