import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsOnboardingSeenUseCase {
  final OnboardingStore _onboardingStore;

  IsOnboardingSeenUseCase(this._onboardingStore);

  Future<bool> call() => _onboardingStore.isOnboardingSeen();
}
