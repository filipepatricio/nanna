import 'package:better_informed_mobile/domain/onboarding/data/onboarding_version.dart';
import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSeenOnboardingVersionUseCase {
  GetSeenOnboardingVersionUseCase(
    this._onboardingStore,
    this._userStore,
  );

  final OnboardingStore _onboardingStore;
  final UserStore _userStore;

  Future<OnboardingVersion?> call() async {
    final userUuid = await _userStore.getCurrentUserUuid();
    return _onboardingStore.getSeenOnboardingVersion(userUuid);
  }
}
