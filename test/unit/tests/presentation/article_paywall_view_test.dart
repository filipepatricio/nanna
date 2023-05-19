import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_cell.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/trial_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes.dart';
import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets('paywall is shown for blocked article', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    final activeSubscriptionUseCase = FakeGetActiveSubscriptionUseCase(activeSubscription: ActiveSubscription.free());

    final getArticleUseCase = MockGetArticleUseCase();
    when(getArticleUseCase.single(any)).thenAnswer(
      (_) async => Article(
        metadata: TestData.premiumArticleWithAudioAndLocked,
        content: TestData.lockedArticle.content,
      ),
    );

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => activeSubscriptionUseCase);
        getIt.registerFactory<GetArticleUseCase>(() => getArticleUseCase);
      },
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudioAndLocked.slug),
        ],
      ),
    );

    expectToFindPaywall();

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('paywall is shown when in guest mode', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    final isGuestModeUseCase = MockIsGuestModeUseCase();
    when(isGuestModeUseCase.call()).thenAnswer((_) async => true);

    final activeSubscriptionUseCase = FakeGetActiveSubscriptionUseCase(activeSubscription: ActiveSubscription.free());

    final getArticleUseCase = MockGetArticleUseCase();
    when(getArticleUseCase.single(any)).thenAnswer(
      (_) async => Article(
        metadata: TestData.premiumArticleWithAudio,
        content: TestData.lockedArticle.content,
      ),
    );

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsGuestModeUseCase>(() => isGuestModeUseCase);
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => activeSubscriptionUseCase);
        getIt.registerFactory<GetArticleUseCase>(() => getArticleUseCase);
      },
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
        ],
      ),
    );

    expectToFindPaywall();

    debugDefaultTargetPlatformOverride = null;
  });
}

void expectToFindPaywall() {
  expect(find.byType(SubscriptionPlanCell), findsNWidgets(2));
  expect(find.byType(TrialTimeline), findsOneWidget);
  expect(find.byText(l10n.subscription_restorePurchase), findsOneWidget);
  expect(find.byText(l10n.subscription_redeemCode), findsOneWidget);

  final buttonFinder = find.byWidgetPredicate(
    (widget) => widget is InformedFilledButton && widget.text == l10n.subscription_button_trialText,
  );
  expect(buttonFinder, findsOneWidget);
}
