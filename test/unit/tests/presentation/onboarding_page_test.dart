import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/set_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'user can redeem gift',
    (tester) async {},
  );

  testWidgets(
    'user can skip onboarding',
    (tester) async {
      final isSignedInUseCase = MockIsSignedInUseCase();
      when(isSignedInUseCase.call()).thenAnswer((_) async => false);

      final setGuestModeUseCase = MockSetGuestModeUseCase();
      when(setGuestModeUseCase.call()).thenAnswer((_) async {});

      final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
      when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => ActiveSubscription.free());
      when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

      final router = await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
          getIt.registerFactory<SetGuestModeUseCase>(() => setGuestModeUseCase);
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        },
      );

      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(router.stack.length, 1);

      await tester.tap(find.byType(SkipButton));
      await tester.pumpAndSettle();

      expect(find.byType(MainPage), findsOneWidget);
      expect(router.stack.length, 1);

      verify(setGuestModeUseCase.call()).called(1);
    },
  );
}
