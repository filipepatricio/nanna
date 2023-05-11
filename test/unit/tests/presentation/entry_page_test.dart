import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  group('cubit', () {
    late MockIsSignedInUseCase isSignedInUseCase;
    late MockInitializeFeatureFlagsUseCase initializeFeatureFlagsUseCase;
    late MockInitializeAttributionUseCase initializeAttributionUseCase;
    late MockSaveReleaseNoteIfFirstRunUseCase saveReleaseNoteIfFirstRunUseCase;
    late MockIdentifyAnalyticsUserUseCase identifyAnalyticsUserUseCase;
    late MockInitializePurchasesUseCase initializePurchasesUseCase;
    late GetActiveSubscriptionUseCase getActiveSubscriptionUseCase;
    late MockIsGuestModeUseCase isGuestModeUseCase;

    late EntryPageCubit cubit;

    setUp(() {
      isSignedInUseCase = MockIsSignedInUseCase();
      initializeFeatureFlagsUseCase = MockInitializeFeatureFlagsUseCase();
      initializeAttributionUseCase = MockInitializeAttributionUseCase();
      saveReleaseNoteIfFirstRunUseCase = MockSaveReleaseNoteIfFirstRunUseCase();
      identifyAnalyticsUserUseCase = MockIdentifyAnalyticsUserUseCase();
      initializePurchasesUseCase = MockInitializePurchasesUseCase();
      getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
      isGuestModeUseCase = MockIsGuestModeUseCase();

      when(isGuestModeUseCase()).thenAnswer((_) async => false);

      cubit = EntryPageCubit(
        isSignedInUseCase,
        initializeFeatureFlagsUseCase,
        initializeAttributionUseCase,
        saveReleaseNoteIfFirstRunUseCase,
        identifyAnalyticsUserUseCase,
        initializePurchasesUseCase,
        getActiveSubscriptionUseCase,
        isGuestModeUseCase,
      );
    });

    testWidgets(
      'user is signed in, subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);

        await cubit.initialize();

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(isSignedInUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);

        verifyNever(getActiveSubscriptionUseCase());

        expect(cubit.state, EntryPageState.signedIn());
      },
    );
    testWidgets(
      'user is signed in, not subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());

        await cubit.initialize();

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(isSignedInUseCase()).called(1);
        verify(initializeFeatureFlagsUseCase()).called(1);
        verify(identifyAnalyticsUserUseCase()).called(1);
        verify(initializeAttributionUseCase()).called(1);

        verifyNever(getActiveSubscriptionUseCase());

        expect(cubit.state, EntryPageState.signedIn());
      },
    );

    testWidgets(
      'user is not signed in, subcribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => false);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);

        await cubit.initialize();

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(isSignedInUseCase()).called(1);
        verify(getActiveSubscriptionUseCase()).called(1);

        verifyNever(initializeFeatureFlagsUseCase());
        verifyNever(identifyAnalyticsUserUseCase());
        verifyNever(initializeAttributionUseCase());

        expect(cubit.state, EntryPageState.subscribed());
      },
    );

    testWidgets(
      'user is not signed in, not subscribed',
      (tester) async {
        when(isSignedInUseCase()).thenAnswer((_) async => false);
        when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());

        await cubit.initialize();

        verify(saveReleaseNoteIfFirstRunUseCase()).called(1);
        verify(initializePurchasesUseCase()).called(1);
        verify(isSignedInUseCase()).called(1);
        verify(getActiveSubscriptionUseCase()).called(1);

        verifyNever(initializeFeatureFlagsUseCase());
        verifyNever(identifyAnalyticsUserUseCase());
        verifyNever(initializeAttributionUseCase());

        expect(cubit.state, EntryPageState.notSignedIn());
      },
    );
  });

  group('navigation', () {
    testWidgets(
      'app starts with main page for signed in users',
      (tester) async {
        final router = await tester.startApp();
        expect(find.byType(MainPage), findsOneWidget);
        expect(router.stack.length, 1);
      },
    );

    testWidgets(
      'app starts with main page for guest users',
      (tester) async {
        //TODO: implement 'app starts with main page for guest users'
      },
    );

    testWidgets(
      'app starts with onboarding for fresh installs',
      (tester) async {
        final isSignedInUseCase = MockIsSignedInUseCase();
        when(isSignedInUseCase.call()).thenAnswer((_) async => false);

        final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
        when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => ActiveSubscription.free());
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

        final router = await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
          },
        );

        expect(find.byType(OnboardingPage), findsOneWidget);
        expect(router.stack.length, 1);
      },
    );

    testWidgets(
      'sign in for subscribed, not signed in users at startup',
      (tester) async {
        final isSignedInUseCase = MockIsSignedInUseCase();
        when(isSignedInUseCase.call()).thenAnswer((_) async => false);

        final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
        when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => TestData.activeSubscription);
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscription));

        final router = await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
          },
        );

        expect(find.byType(SignInPage), findsOneWidget);
        expect(router.stack.length, 1);
      },
    );

    testWidgets(
      'sign in is required after successful subscription',
      (tester) async {
        final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
        final isSignedInUseCase = MockIsSignedInUseCase();
        when(isSignedInUseCase.call()).thenAnswer((_) async => true);
        when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));

        final router = await tester.startApp(
          // initialRoute: const OnboardingPageRoute(),
          dependencyOverride: (getIt) async {
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
          },
        );

        when(isSignedInUseCase.call()).thenAnswer((_) async => false);

        await router.replaceAll([const OnboardingPageRoute()]);
        await tester.pumpAndSettle();

        expect(find.byType(SignInPage), findsOneWidget);
        expect(router.stack.length, 1);
      },
    );

    testWidgets(
      'user can redeem gift or skip onboarding',
      (tester) async {
        //TODO: implement 'user can redeem gift or skip onboarding'
      },
    );

    testWidgets(
      'user can subscribe or sign in from onboarding',
      (tester) async {
        final isSignedInUseCase = MockIsSignedInUseCase();
        when(isSignedInUseCase.call()).thenAnswer((_) async => false);

        final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
        when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => ActiveSubscription.free());
        when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

        final router = await tester.startApp(
          dependencyOverride: (getIt) async {
            getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
            getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
          },
        );

        expect(router.stack.length, 1);

        await tester.tap(find.byText(l10n.onboarding_button_getStartedWithPremium));
        await tester.pumpAndSettle();

        expect(find.byType(SubscriptionPage), findsOneWidget);
        expect(router.stack.length, 2);

        await tester.tap(find.bySvgAssetName(AppVectorGraphics.close));
        await tester.pumpAndSettle();

        expect(find.byType(OnboardingPage), findsOneWidget);
        expect(router.stack.length, 1);

        await tester.tap(find.byText(l10n.onboarding_button_alreadyHaveAnAccount));
        await tester.pumpAndSettle();

        expect(find.byType(SignInPage), findsOneWidget);
        expect(router.stack.length, 2);

        await tester.tap(find.bySvgAssetName(AppVectorGraphics.close));
        await tester.pumpAndSettle();

        expect(find.byType(OnboardingPage), findsOneWidget);
        expect(router.stack.length, 1);
      },
    );
  });
}
