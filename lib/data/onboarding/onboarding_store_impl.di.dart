import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingStore)
class OnboardingStoreImpl extends OnboardingStore {
  final OnboardingDatabase _database;

  OnboardingStoreImpl(this._database);

  @override
  Future<bool> isUserOnboardingSeen(String userUuid) async {
    return await _database.isOnboardingSeen(userUuid);
  }

  @override
  Future<void> setUserOnboardingSeen(String userUuid) async {
    await _database.setOnboardingSeen(userUuid);
  }

  @override
  Future<void> resetUserOnboarding(String userUuid) => _database.resetOnboarding(userUuid);
}
