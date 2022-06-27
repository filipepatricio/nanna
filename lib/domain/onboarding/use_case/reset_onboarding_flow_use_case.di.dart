import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetOnboardingFlowUseCase {
  ResetOnboardingFlowUseCase(
    this._onboardingStore,
    this._userStore,
  );
  final OnboardingStore _onboardingStore;
  final UserStore _userStore;

  Future<void> call() async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _onboardingStore.resetUserOnboarding(currentUserUuid);
  }
}
