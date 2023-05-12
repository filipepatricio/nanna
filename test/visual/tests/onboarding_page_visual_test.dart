import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(OnboardingPage, (tester) async {
    final isSignedInUseCase = MockIsSignedInUseCase();
    when(isSignedInUseCase.call()).thenAnswer((_) async => false);

    final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => ActiveSubscription.free());
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
      },
    );
    await tester.matchGoldenFile('onboarding_page_(step_1)');
    await tester.fling(find.byType(PageView).first, const Offset(-1000, 0), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('onboarding_page_(step_2)');
    await tester.fling(find.byType(PageView).first, const Offset(-1000, 0), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('onboarding_page_(step_3)');
  });
}
