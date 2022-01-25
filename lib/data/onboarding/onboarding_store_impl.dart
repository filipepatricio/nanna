import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingStore)
class OnboardingStoreImpl extends OnboardingStore {
  final OnboardingDatabase _database;

  OnboardingStoreImpl(this._database);

  @override
  Future<bool> isOnboardingSeen() async {
    return await _database.isOnboardingSeen();
  }

  @override
  Future<void> setOnboardingSeen() async {
    await _database.setOnboardingSeen();
  }

  @override
  Future<void> resetOnboarding() => _database.resetOnboarding();
}
