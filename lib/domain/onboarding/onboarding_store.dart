import 'package:better_informed_mobile/domain/onboarding/data/onboarding_version.dart';

abstract class OnboardingStore {
  Future<bool> isUserOnboardingSeen(String userUuid);

  Future<OnboardingVersion?> getSeenOnboardingVersion(String userUuid);

  Future<void> setUserOnboardingSeen(String userUuid);

  Future<void> resetUserOnboarding(String userUuid);

  OnboardingVersion get currentVersion;
}
