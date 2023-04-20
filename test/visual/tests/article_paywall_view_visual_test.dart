import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_view.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_markdown.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../fakes.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    '${ArticlePaywallView}_(trial)',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final article = Article(
        metadata: TestData.premiumArticleWithAudioAndLocked,
        content: TestData.fullArticle.content,
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetSubscriptionPlansUseCase>(
            () => FakeGetSubscriptionPlansUseCase(),
          );
        },
        initialRoute: PlaceholderPageRoute(
          child: SnackbarParentView(
            child: Scaffold(
              body: SingleChildScrollView(
                reverse: true,
                child: ArticlePaywallView(
                  article: article,
                  child: ArticleContentMarkdown(
                    markdown: article.shortText,
                    categoryColor: article.metadata.category.color ?? AppColors.brandAccent,
                    shareTextCallback: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
      debugDefaultTargetPlatformOverride = null;
    },
    testConfig: TestConfig.autoHeight(),
  );

  visualTest(
    '${ArticlePaywallView}_(no_trial)',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final article = Article(
        metadata: TestData.premiumArticleWithAudioAndLocked,
        content: TestData.fullArticle.content,
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetSubscriptionPlansUseCase>(
            () => FakeGetSubscriptionPlansUseCase(),
          );
        },
        initialRoute: PlaceholderPageRoute(
          child: SnackbarParentView(
            child: Scaffold(
              body: SingleChildScrollView(
                reverse: true,
                child: ArticlePaywallView(
                  article: article,
                  child: ArticleContentMarkdown(
                    markdown: article.shortText,
                    categoryColor: article.metadata.category.color ?? AppColors.brandAccent,
                    shareTextCallback: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
      debugDefaultTargetPlatformOverride = null;
    },
    testConfig: TestConfig.autoHeight(),
  );
}

extension on Article {
  String get shortText => content.content.characters.take(content.content.length ~/ 10).toString();
}
