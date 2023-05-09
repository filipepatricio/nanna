import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_topic_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_related_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fakes.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  late FakeGetActiveSubscriptionUseCase activeSubscriptionUseCase;
  late MockGetOtherBriefEntriesUseCase getOtherBriefEntriesUseCase;
  late MockGetOtherTopicEntriesUseCase getOtherTopicEntriesUseCase;
  late MockGetFeaturedCategoriesUseCase getFeaturedCategoriesUseCase;
  late MockGetRelatedContentUseCase getRelatedContentUseCase;
  late MockGetArticleUseCase getArticleUseCase;

  setUp(() {
    activeSubscriptionUseCase = FakeGetActiveSubscriptionUseCase(activeSubscription: ActiveSubscription.free());
    getOtherBriefEntriesUseCase = MockGetOtherBriefEntriesUseCase();
    getOtherTopicEntriesUseCase = MockGetOtherTopicEntriesUseCase();
    getFeaturedCategoriesUseCase = MockGetFeaturedCategoriesUseCase();
    getRelatedContentUseCase = MockGetRelatedContentUseCase();
    getArticleUseCase = MockGetArticleUseCase();

    when(getOtherBriefEntriesUseCase(any, any)).thenAnswer((_) async => []);
    when(getOtherTopicEntriesUseCase(any, any)).thenAnswer((_) async => []);
    when(getFeaturedCategoriesUseCase()).thenAnswer((_) async => []);
    when(getRelatedContentUseCase(any)).thenAnswer((_) async => []);
    when(getArticleUseCase.single(any)).thenAnswer(
      (_) async => Article(
        metadata: TestData.premiumArticleWithAudioAndLocked,
        content: TestData.lockedArticle.content,
      ),
    );
  });

  visualTest(
    '${ArticlePaywallView}_(trial)',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetArticleUseCase>(() => getArticleUseCase);
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => activeSubscriptionUseCase);
          getIt.registerFactory<GetOtherBriefEntriesUseCase>(() => getOtherBriefEntriesUseCase);
          getIt.registerFactory<GetOtherTopicEntriesUseCase>(() => getOtherTopicEntriesUseCase);
          getIt.registerFactory<GetFeaturedCategoriesUseCase>(() => getFeaturedCategoriesUseCase);
          getIt.registerFactory<GetRelatedContentUseCase>(() => getRelatedContentUseCase);
        },
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudioAndLocked.slug),
          ],
        ),
      );

      await tester.matchGoldenFile();
      debugDefaultTargetPlatformOverride = null;
    },
    testConfig: TestConfig.autoHeight(),
  );

  visualTest(
    '${ArticlePaywallView}_(no_trial)',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final getSubscriptionPlansUseCase = FakeGetSubscriptionPlansUseCase(TestData.subscriptionPlansWithoutTrial);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetArticleUseCase>(() => getArticleUseCase);
          getIt.registerFactory<GetSubscriptionPlansUseCase>(() => getSubscriptionPlansUseCase);
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => activeSubscriptionUseCase);
          getIt.registerFactory<GetOtherBriefEntriesUseCase>(() => getOtherBriefEntriesUseCase);
          getIt.registerFactory<GetOtherTopicEntriesUseCase>(() => getOtherTopicEntriesUseCase);
          getIt.registerFactory<GetFeaturedCategoriesUseCase>(() => getFeaturedCategoriesUseCase);
          getIt.registerFactory<GetRelatedContentUseCase>(() => getRelatedContentUseCase);
        },
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudioAndLocked.slug),
          ],
        ),
      );

      await tester.matchGoldenFile();
      debugDefaultTargetPlatformOverride = null;
    },
    testConfig: TestConfig.autoHeight(),
  );
}
