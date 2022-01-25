import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetOnboardingSeenUseCase {
  final OnboardingStore _onboardingStore;

  SetOnboardingSeenUseCase(this._onboardingStore);

  Future<void> call() => _onboardingStore.setOnboardingSeen();
}
