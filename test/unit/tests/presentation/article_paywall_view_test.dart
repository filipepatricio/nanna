import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/article_paywall_subscription_plan_pack.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_article_paywall_preferred_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_view.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes.dart';
import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets('pressing trial subscription button invokes purchase', (tester) async {
    final article = Article(
      metadata: TestData.premiumArticleWithAudioAndLocked,
      content: TestData.fullArticle.content,
    );
    final plan = TestData.subscriptionPlansWithTrial.first;

    final purchaseSubscriptionUseCase = MockPurchaseSubscriptionUseCase();
    final getArticlePaywallPreferredPlanUseCase = FakeGetArticlePaywallPreferredPlanUseCase(
      ArticlePaywallSubscriptionPlanPack.singleTrial(plan),
    );

    when(purchaseSubscriptionUseCase.call(plan)).thenAnswer((realInvocation) async => true);

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<PurchaseSubscriptionUseCase>(() => purchaseSubscriptionUseCase);
        getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(() => getArticlePaywallPreferredPlanUseCase);
      },
      initialRoute: PlaceholderPageRoute(
        child: SnackbarParentView(
          child: Scaffold(
            body: SingleChildScrollView(
              child: ArticlePaywallView(
                article: article,
                child: Text(article.content.content),
              ),
            ),
          ),
        ),
      ),
    );

    final subscribeButton = find.byType(SubscribeButton);

    await tester.dragUntilVisible(subscribeButton, find.byType(Scrollable), const Offset(0, 200));
    await tester.tap(subscribeButton);

    verify(purchaseSubscriptionUseCase.call(plan));
  });

  testWidgets('pressing standard subscription button invokes purchase for seelcted plan', (tester) async {
    final article = Article(
      metadata: TestData.premiumArticleWithAudioAndLocked,
      content: TestData.fullArticle.content,
    );
    final plans = TestData.subscriptionPlansWithoutTrial;

    final purchaseSubscriptionUseCase = MockPurchaseSubscriptionUseCase();
    final getArticlePaywallPreferredPlanUseCase = FakeGetArticlePaywallPreferredPlanUseCase(
      ArticlePaywallSubscriptionPlanPack.multiple(SubscriptionPlanGroup(plans: plans)),
    );

    when(purchaseSubscriptionUseCase.call(plans.last)).thenAnswer((realInvocation) async => true);

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<PurchaseSubscriptionUseCase>(() => purchaseSubscriptionUseCase);
        getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(() => getArticlePaywallPreferredPlanUseCase);
      },
      initialRoute: PlaceholderPageRoute(
        child: SnackbarParentView(
          child: Scaffold(
            body: SingleChildScrollView(
              child: ArticlePaywallView(
                article: article,
                child: Text(article.content.content),
              ),
            ),
          ),
        ),
      ),
    );

    final subscribeButton = find.byType(SubscribeButton);
    await tester.dragUntilVisible(subscribeButton, find.byType(Scrollable), const Offset(0, 200));

    await tester.tap(find.byType(SubscriptionPlanCard).last);
    await tester.pumpAndSettle();
    await tester.tap(subscribeButton);

    verify(purchaseSubscriptionUseCase.call(plans.last));
  });
}
