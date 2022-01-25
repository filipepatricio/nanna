import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetOnboardingFlowUseCase {
  final OnboardingStore _onboardingStore;

  ResetOnboardingFlowUseCase(this._onboardingStore);

  Future<void> call() => _onboardingStore.resetOnboarding();
}
