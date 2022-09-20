import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/subscription/data/article_paywall_subscription_plan_pack.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_article_paywall_preferred_plan_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${ArticlePaywallView}_(with_short_article)', (tester) async {
    final article = Article(
      metadata: TestData.premiumArticleWithAudioAndLocked,
      content: TestData.fullArticle.content,
    );

    final shortText = article.content.content.characters.take(article.content.content.length ~/ 10).toString();

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(
          () => FakeGetArticlePaywallPreferredPlanUseCase(
            ArticlePaywallSubscriptionPlanPack.singleTrial(TestData.subscriptionPlansWithTrial.first),
          ),
        );
      },
      initialRoute: PlaceholderPageRoute(
        child: Scaffold(
          body: SingleChildScrollView(
            child: ArticlePaywallView(
              article: article,
              onPurchaseSuccess: () {},
              onGeneralError: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Text(shortText),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${ArticlePaywallView}_(trial)', (tester) async {
    final article = Article(
      metadata: TestData.premiumArticleWithAudioAndLocked,
      content: TestData.fullArticle.content,
    );

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(
          () => FakeGetArticlePaywallPreferredPlanUseCase(
            ArticlePaywallSubscriptionPlanPack.singleTrial(TestData.subscriptionPlansWithTrial.first),
          ),
        );
      },
      initialRoute: PlaceholderPageRoute(
        child: Scaffold(
          body: SingleChildScrollView(
            reverse: true,
            child: ArticlePaywallView(
              article: article,
              onPurchaseSuccess: () {},
              onGeneralError: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Text(article.content.content),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(find.byType(LinkLabel), 100);

    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${ArticlePaywallView}_(no_trial)', (tester) async {
    final article = Article(
      metadata: TestData.premiumArticleWithAudioAndLocked,
      content: TestData.fullArticle.content,
    );

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(
          () => FakeGetArticlePaywallPreferredPlanUseCase(
            ArticlePaywallSubscriptionPlanPack.multiple(TestData.subscriptionPlansWithoutTrial),
          ),
        );
      },
      initialRoute: PlaceholderPageRoute(
        child: Scaffold(
          body: SingleChildScrollView(
            reverse: true,
            child: ArticlePaywallView(
              article: article,
              onPurchaseSuccess: () {},
              onGeneralError: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Text(article.content.content),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(find.byType(LinkLabel).first, 100);

    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });
}
