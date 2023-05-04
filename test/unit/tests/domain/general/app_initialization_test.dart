import 'package:better_informed_mobile/domain/analytics/use_case/identify_analytics_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/request_tracking_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/save_release_note_if_first_run_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_wait_for_ui_active_state_use_case.di.dart';
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
  late GetActiveSubscriptionUseCase getActiveSubscriptionUseCase;
  late MockAuthRepository authRepository;
  late MockGetUserUseCase getUserUseCase;
  late SignInPageCubit signInPageCubit;
  late RequestNotificationPermissionUseCase requestNotificationPermissionUseCase;
  late RequestTrackingPermissionUseCase requestTrackingPermissionUseCase;
  late ShouldWaitForUiActiveStateUseCase shouldWaitForUiActiveStateUseCase;

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
    requestNotificationPermissionUseCase = MockRequestNotificationPermissionUseCase();
    requestTrackingPermissionUseCase = MockRequestTrackingPermissionUseCase();
    shouldWaitForUiActiveStateUseCase = MockShouldWaitForUiActiveStateUseCase();

    final signInUseCase = SignInUseCase(
      authRepository,
      MockAuthStore(),
      MockUserStore(),
      getUserUseCase,
      initializePurchasesUseCase,
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
    );
  });

  group('initialization use cases are referenced at least once', () {
    testWidgets(
      'user is signed in, subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));
        when(requestNotificationPermissionUseCase.call()).thenAnswer((_) => Future.value(false));
        when(shouldWaitForUiActiveStateUseCase.call()).thenAnswer((_) => Future.value(true));

        await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<InitializeFeatureFlagsUseCase>(() => initializeFeatureFlagsUseCase);
            getIt.registerFactory<InitializeAttributionUseCase>(() => initializeAttributionUseCase);
            getIt.registerFactory<SaveReleaseNoteIfFirstRunUseCase>(() => saveReleaseNoteIfFirstRunUseCase);
            getIt.registerFactory<IdentifyAnalyticsUserUseCase>(() => identifyAnalyticsUserUseCase);
            getIt.registerFactory<InitializePurchasesUseCase>(() => initializePurchasesUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<RequestNotificationPermissionUseCase>(() => requestNotificationPermissionUseCase);
            getIt.registerFactory<RequestTrackingPermissionUseCase>(() => requestTrackingPermissionUseCase);
            getIt.registerFactory<ShouldWaitForUiActiveStateUseCase>(() => shouldWaitForUiActiveStateUseCase);
          },
        );

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(requestNotificationPermissionUseCase()).called(1);
        verify(requestTrackingPermissionUseCase()).called(1);
      },
    );
    testWidgets(
      'user is signed in, not subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));
        when(requestNotificationPermissionUseCase.call()).thenAnswer((_) => Future.value(false));
        when(shouldWaitForUiActiveStateUseCase.call()).thenAnswer((_) => Future.value(true));

        await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<InitializeFeatureFlagsUseCase>(() => initializeFeatureFlagsUseCase);
            getIt.registerFactory<InitializeAttributionUseCase>(() => initializeAttributionUseCase);
            getIt.registerFactory<SaveReleaseNoteIfFirstRunUseCase>(() => saveReleaseNoteIfFirstRunUseCase);
            getIt.registerFactory<IdentifyAnalyticsUserUseCase>(() => identifyAnalyticsUserUseCase);
            getIt.registerFactory<InitializePurchasesUseCase>(() => initializePurchasesUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<RequestNotificationPermissionUseCase>(() => requestNotificationPermissionUseCase);
            getIt.registerFactory<RequestTrackingPermissionUseCase>(() => requestTrackingPermissionUseCase);
            getIt.registerFactory<ShouldWaitForUiActiveStateUseCase>(() => shouldWaitForUiActiveStateUseCase);
          },
        );

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(requestNotificationPermissionUseCase()).called(1);
        verify(requestTrackingPermissionUseCase()).called(1);
      },
    );

    testWidgets(
      'user subcribed but not signed in. signs in',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => false);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));
        when(getUserUseCase()).thenAnswer((_) async => TestData.user);

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
            getIt.registerFactory<RequestTrackingPermissionUseCase>(() => requestTrackingPermissionUseCase);
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

        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase(any)).called(1);
        verify(getUserUseCase()).called(1);

        verifyNever(requestTrackingPermissionUseCase());
      },
    );

    testWidgets(
      'user is not signed in and not subscribed. signs in',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => false);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));
        when(getUserUseCase()).thenAnswer((_) async => TestData.user);

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
            getIt.registerFactory<RequestTrackingPermissionUseCase>(() => requestTrackingPermissionUseCase);
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

        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase(any)).called(1);
        verify(getUserUseCase()).called(1);

        verifyNever(requestTrackingPermissionUseCase());
      },
    );
  });
}
