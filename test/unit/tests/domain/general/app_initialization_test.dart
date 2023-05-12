import 'package:better_informed_mobile/domain/analytics/use_case/identify_analytics_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/save_release_note_if_first_run_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/force_subscription_status_sync_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/request_permissions_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_cubit.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';
import '../../../unit_test_utils.dart';

void main() {
  late MockIsSignedInUseCase isSignedInUseCase;
  late MockInitializeFeatureFlagsUseCase initializeFeatureFlagsUseCase;
  late MockInitializeAttributionUseCase initializeAttributionUseCase;
  late MockSaveReleaseNoteIfFirstRunUseCase saveReleaseNoteIfFirstRunUseCase;
  late MockIdentifyAnalyticsUserUseCase identifyAnalyticsUserUseCase;
  late MockInitializePurchasesUseCase initializePurchasesUseCase;
  late MockGetActiveSubscriptionUseCase getActiveSubscriptionUseCase;
  late MockAuthRepository authRepository;
  late MockGetUserUseCase getUserUseCase;
  late SignInPageCubit signInPageCubit;
  late MockRequestPermissionsUseCase requestPermissionsUseCase;
  late MockHasActiveSubscriptionUseCase hasActiveSubscriptionUseCase;
  late MockForceSubscriptionStatusSyncUseCase forceSubscriptionStatusSyncUseCase;
  late MockClearGuestModeUseCase clearGuestModeUseCase;

  setUp(() {
    isSignedInUseCase = MockIsSignedInUseCase();
    initializeFeatureFlagsUseCase = MockInitializeFeatureFlagsUseCase();
    initializeAttributionUseCase = MockInitializeAttributionUseCase();
    saveReleaseNoteIfFirstRunUseCase = MockSaveReleaseNoteIfFirstRunUseCase();
    identifyAnalyticsUserUseCase = MockIdentifyAnalyticsUserUseCase();
    initializePurchasesUseCase = MockInitializePurchasesUseCase();
    getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    authRepository = MockAuthRepository();
    getUserUseCase = MockGetUserUseCase();
    requestPermissionsUseCase = MockRequestPermissionsUseCase();
    hasActiveSubscriptionUseCase = MockHasActiveSubscriptionUseCase();
    forceSubscriptionStatusSyncUseCase = MockForceSubscriptionStatusSyncUseCase();
    clearGuestModeUseCase = MockClearGuestModeUseCase();

    final signInUseCase = SignInUseCase(
      authRepository,
      MockAuthStore(),
      MockUserStore(),
      identifyAnalyticsUserUseCase,
    );

    signInPageCubit = SignInPageCubit(
      MockIsEmailValidUseCase(),
      MockSendMagicLinkUseCase(),
      MockSubscribeForMagicLinkTokenUseCase(),
      initializeFeatureFlagsUseCase,
      initializeAttributionUseCase,
      initializePurchasesUseCase,
      MockRestorePurchaseUseCase(),
      signInUseCase,
      MockRunIntitialBookmarkSyncUseCase(),
      getUserUseCase,
      hasActiveSubscriptionUseCase,
      forceSubscriptionStatusSyncUseCase,
      clearGuestModeUseCase,
    );
  });

  group('initialization use cases are referenced at least once', () {
    testWidgets(
      'user is signed in, subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));
        when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
        when(forceSubscriptionStatusSyncUseCase()).thenAnswer((_) async => true);

        await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<InitializeFeatureFlagsUseCase>(() => initializeFeatureFlagsUseCase);
            getIt.registerFactory<InitializeAttributionUseCase>(() => initializeAttributionUseCase);
            getIt.registerFactory<SaveReleaseNoteIfFirstRunUseCase>(() => saveReleaseNoteIfFirstRunUseCase);
            getIt.registerFactory<IdentifyAnalyticsUserUseCase>(() => identifyAnalyticsUserUseCase);
            getIt.registerFactory<InitializePurchasesUseCase>(() => initializePurchasesUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<RequestPermissionsUseCase>(() => requestPermissionsUseCase);
            getIt.registerFactory<HasActiveSubscriptionUseCase>(() => hasActiveSubscriptionUseCase);
            getIt.registerFactory<ForceSubscriptionStatusSyncUseCase>(() => forceSubscriptionStatusSyncUseCase);
          },
        );

        verifyNever(forceSubscriptionStatusSyncUseCase());
        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(requestPermissionsUseCase()).called(1);
      },
    );
    testWidgets(
      'user is signed in, not subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));
        when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);
        when(forceSubscriptionStatusSyncUseCase()).thenAnswer((_) async => true);

        await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<InitializeFeatureFlagsUseCase>(() => initializeFeatureFlagsUseCase);
            getIt.registerFactory<InitializeAttributionUseCase>(() => initializeAttributionUseCase);
            getIt.registerFactory<SaveReleaseNoteIfFirstRunUseCase>(() => saveReleaseNoteIfFirstRunUseCase);
            getIt.registerFactory<IdentifyAnalyticsUserUseCase>(() => identifyAnalyticsUserUseCase);
            getIt.registerFactory<InitializePurchasesUseCase>(() => initializePurchasesUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<RequestPermissionsUseCase>(() => requestPermissionsUseCase);
            getIt.registerFactory<HasActiveSubscriptionUseCase>(() => hasActiveSubscriptionUseCase);
            getIt.registerFactory<ForceSubscriptionStatusSyncUseCase>(() => forceSubscriptionStatusSyncUseCase);
          },
        );

        verifyNever(forceSubscriptionStatusSyncUseCase());
        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(requestPermissionsUseCase()).called(1);
      },
    );

    testWidgets(
      'user subcribed but not signed in. signs in',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => false);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));
        when(getUserUseCase()).thenAnswer((_) async => TestData.user);
        when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
        when(forceSubscriptionStatusSyncUseCase()).thenAnswer((_) async => true);

        await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<InitializeFeatureFlagsUseCase>(() => initializeFeatureFlagsUseCase);
            getIt.registerFactory<InitializeAttributionUseCase>(() => initializeAttributionUseCase);
            getIt.registerFactory<SaveReleaseNoteIfFirstRunUseCase>(() => saveReleaseNoteIfFirstRunUseCase);
            getIt.registerFactory<IdentifyAnalyticsUserUseCase>(() => identifyAnalyticsUserUseCase);
            getIt.registerFactory<InitializePurchasesUseCase>(() => initializePurchasesUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<AuthRepository>(() => authRepository);
            getIt.registerFactory<RequestPermissionsUseCase>(() => requestPermissionsUseCase);
            getIt.registerFactory<HasActiveSubscriptionUseCase>(() => hasActiveSubscriptionUseCase);
            getIt.registerFactory<ForceSubscriptionStatusSyncUseCase>(() => forceSubscriptionStatusSyncUseCase);
          },
        );

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);

        verifyNever(initializeFeatureFlagsUseCase());
        verifyNever(identifyAnalyticsUserUseCase());
        verifyNever(initializeAttributionUseCase());

        when(authRepository.signInWithMagicLinkToken(any)).thenAnswer(
          (realInvocation) async => AuthResult(
            AuthToken(accessToken: 'accessToken', refreshToken: 'refreshToken'),
            'method',
            'userUuid',
          ),
        );

        await signInPageCubit.signInWithMagicLink('token');

        verify(forceSubscriptionStatusSyncUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase(any)).called(1);
        verify(getUserUseCase()).called(1);

        verifyNever(requestPermissionsUseCase());
      },
    );

    testWidgets(
      'user is not signed in and not subscribed. signs in',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => false);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));
        when(getUserUseCase()).thenAnswer((_) async => TestData.user);
        when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);
        when(forceSubscriptionStatusSyncUseCase()).thenAnswer((_) async => true);

        await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<InitializeFeatureFlagsUseCase>(() => initializeFeatureFlagsUseCase);
            getIt.registerFactory<InitializeAttributionUseCase>(() => initializeAttributionUseCase);
            getIt.registerFactory<SaveReleaseNoteIfFirstRunUseCase>(() => saveReleaseNoteIfFirstRunUseCase);
            getIt.registerFactory<IdentifyAnalyticsUserUseCase>(() => identifyAnalyticsUserUseCase);
            getIt.registerFactory<InitializePurchasesUseCase>(() => initializePurchasesUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<SignInPageCubit>(() => signInPageCubit);
            getIt.registerFactory<RequestPermissionsUseCase>(() => requestPermissionsUseCase);
            getIt.registerFactory<HasActiveSubscriptionUseCase>(() => hasActiveSubscriptionUseCase);
            getIt.registerFactory<ForceSubscriptionStatusSyncUseCase>(() => forceSubscriptionStatusSyncUseCase);
          },
        );

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);

        verifyNever(forceSubscriptionStatusSyncUseCase());
        verifyNever(initializeFeatureFlagsUseCase());
        verifyNever(identifyAnalyticsUserUseCase());
        verifyNever(initializeAttributionUseCase());

        when(authRepository.signInWithMagicLinkToken(any)).thenAnswer(
          (realInvocation) async => AuthResult(
            AuthToken(accessToken: 'accessToken', refreshToken: 'refreshToken'),
            'method',
            'userUuid',
          ),
        );

        await signInPageCubit.signInWithMagicLink('token');

        verifyNever(forceSubscriptionStatusSyncUseCase());
        verify(initializePurchasesUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase(any)).called(1);
        verify(getUserUseCase()).called(1);

        verifyNever(requestPermissionsUseCase());
      },
    );
  });

  //TODO: Add tests for guest mode
}
