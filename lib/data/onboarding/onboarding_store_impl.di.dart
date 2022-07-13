import 'package:better_informed_mobile/data/onboarding/mapper/onboarding_version_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/domain/onboarding/data/onboarding_version.dart';
import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingStore)
class OnboardingStoreImpl extends OnboardingStore {
  OnboardingStoreImpl(
    this._database,
    this._onboardingVersionEntityMapper,
    this._currentOnboardingVersion,
  );

  final OnboardingDatabase _database;
  final OnboardingVersionEntityMapper _onboardingVersionEntityMapper;
  final OnboardingVersion _currentOnboardingVersion;

  static const deprecatedVersion = OnboardingVersion.v1;

  @override
  Future<bool> isUserOnboardingSeen(String userUuid) async {
    final version = await getSeenOnboardingVersion(userUuid);
    return version == currentVersion;
  }

  @override
  Future<void> setUserOnboardingSeen(String userUuid) async {
    final versionCode = _onboardingVersionEntityMapper.from(currentVersion);
    await _database.setOnboardingVersion(userUuid, versionCode);
  }

  @override
  Future<void> resetUserOnboarding(String userUuid) => _database.resetOnboarding(userUuid);

  @override
  Future<OnboardingVersion?> getSeenOnboardingVersion(String userUuid) async {
    final version = await _database.getOnboardingVersion(userUuid);
    if (version != null) {
      return _onboardingVersionEntityMapper.to(version);
    }

    return null;
  }

  @override
  OnboardingVersion get currentVersion => _currentOnboardingVersion;
}
