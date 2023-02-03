import 'package:better_informed_mobile/data/onboarding/onboarding_store_impl.di.dart';
import 'package:better_informed_mobile/domain/onboarding/data/onboarding_version.dart';
import 'package:better_informed_mobile/domain/onboarding/onboarding_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';

void main() {
  const currentVersion = OnboardingVersion.v2;

  late MockOnboardingDatabase onboardingDatabase;
  late MockOnboardingVersionEntityMapper onboardingVersionEntityMapper;
  late OnboardingStore onboardingStore;

  setUp(() {
    onboardingDatabase = MockOnboardingDatabase();
    onboardingVersionEntityMapper = MockOnboardingVersionEntityMapper();
    onboardingStore = OnboardingStoreImpl(
      onboardingDatabase,
      onboardingVersionEntityMapper,
    );
  });

  test('currentVersion returns version passed in constructor', () {
    final store1 = FakeOnboardingStoreImplV1();

    expect(store1.currentVersion, OnboardingVersion.v1);

    final store2 = OnboardingStoreImpl(
      onboardingDatabase,
      onboardingVersionEntityMapper,
    );

    expect(store2.currentVersion, OnboardingVersion.v2);
  });

  test('setUserOnboardingSeen saves currentVersion in database', () async {
    const currentVersionCode = 1;
    const userUuid = '0000';

    when(onboardingVersionEntityMapper.from(currentVersion)).thenAnswer((realInvocation) => currentVersionCode);
    when(onboardingDatabase.setOnboardingVersion(userUuid, currentVersionCode)).thenAnswer((realInvocation) async {});

    await onboardingStore.setUserOnboardingSeen(userUuid);

    verify(onboardingDatabase.setOnboardingVersion(userUuid, currentVersionCode)).called(1);
  });

  test('resetUserOnboarding resets database', () async {
    const userUuid = '0000';

    when(onboardingDatabase.resetOnboarding(userUuid)).thenAnswer((realInvocation) async {});

    await onboardingStore.resetUserOnboarding(userUuid);

    verify(onboardingDatabase.resetOnboarding(userUuid)).called(1);
  });

  group('isOnboardingSeen', () {
    test('returns true if newest version was seen', () async {
      const storedVersionCode = 1;
      const currentVersionCode = 1;
      const userUuid = '0000';

      when(onboardingDatabase.getOnboardingVersion(userUuid)).thenAnswer((realInvocation) async => storedVersionCode);
      when(onboardingVersionEntityMapper.from(currentVersion)).thenAnswer((realInvocation) => currentVersionCode);
      when(onboardingVersionEntityMapper.to(storedVersionCode)).thenAnswer((realInvocation) => OnboardingVersion.v2);

      final actual = await onboardingStore.isUserOnboardingSeen(userUuid);

      expect(actual, true);
    });

    test('returns false if older version was seen', () async {
      const storedVersionCode = 0;
      const currentVersionCode = 1;
      const userUuid = '0000';

      when(onboardingDatabase.getOnboardingVersion(userUuid)).thenAnswer((realInvocation) async => storedVersionCode);
      when(onboardingVersionEntityMapper.from(currentVersion)).thenAnswer((realInvocation) => currentVersionCode);
      when(onboardingVersionEntityMapper.to(storedVersionCode)).thenAnswer((realInvocation) => OnboardingVersion.v1);
      when(onboardingVersionEntityMapper.to(currentVersionCode)).thenAnswer((realInvocation) => OnboardingVersion.v2);

      final actual = await onboardingStore.isUserOnboardingSeen(userUuid);

      expect(actual, false);
    });

    test('returns false if none version was seen', () async {
      const currentVersionCode = 1;
      const userUuid = '0000';

      when(onboardingDatabase.getOnboardingVersion(userUuid)).thenAnswer((realInvocation) async => null);
      when(onboardingVersionEntityMapper.from(currentVersion)).thenAnswer((realInvocation) => currentVersionCode);
      when(onboardingVersionEntityMapper.to(currentVersionCode)).thenAnswer((realInvocation) => OnboardingVersion.v2);

      final actual = await onboardingStore.isUserOnboardingSeen(userUuid);

      expect(actual, false);
    });

    test('returns false if deprecated version was seen', () async {
      const currentVersionCode = 1;
      const userUuid = '0000';

      when(onboardingDatabase.getOnboardingVersion(userUuid)).thenAnswer((realInvocation) async => null);
      when(onboardingVersionEntityMapper.from(currentVersion)).thenAnswer((realInvocation) => currentVersionCode);
      when(onboardingVersionEntityMapper.from(OnboardingStoreImpl.deprecatedVersion)).thenAnswer((realInvocation) => 0);

      final actual = await onboardingStore.isUserOnboardingSeen(userUuid);

      expect(actual, false);
    });
  });

  group('getSeenOnboardingVersion', () {
    test('returns version stored in database when exists', () async {
      const storedVersionCode = 1;
      const userUuid = '0000';
      const expected = OnboardingVersion.v2;

      when(onboardingDatabase.getOnboardingVersion(userUuid)).thenAnswer((realInvocation) async => storedVersionCode);
      when(onboardingVersionEntityMapper.to(storedVersionCode)).thenAnswer((realInvocation) => expected);

      final actual = await onboardingStore.getSeenOnboardingVersion(userUuid);

      expect(actual, expected);
    });

    test('returns null when none version is stored', () async {
      const userUuid = '0000';

      when(onboardingDatabase.getOnboardingVersion(userUuid)).thenAnswer((realInvocation) async => null);

      final actual = await onboardingStore.getSeenOnboardingVersion(userUuid);

      expect(actual, null);
    });
  });
}

class FakeOnboardingStoreImplV1 extends Fake implements OnboardingStoreImpl {
  @override
  OnboardingVersion get currentVersion => OnboardingVersion.v1;
}
