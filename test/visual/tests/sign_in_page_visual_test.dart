import 'dart:async';

import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../finders.dart';
import '../../flutter_test_config.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SignInPage, (tester) async {
    final isSignedInUseCase = MockIsSignedInUseCase();
    when(isSignedInUseCase.call()).thenAnswer((_) async => false);

    final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => TestData.activeSubscription);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscription));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsSignedInUseCase>(() => isSignedInUseCase);
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
      },
    );

    await tester.matchGoldenFile();
  });

  visualTest('${SignInPage}_(modal)', (tester) async {
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

    await tester.tap(find.byText(l10n.onboarding_button_alreadyHaveAnAccount));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
