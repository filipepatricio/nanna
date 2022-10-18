import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/exception/article_geoblocked_exception.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_free_articles_left_warning_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_actions_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(MediaItemPage, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
        ],
      ),
    );

    await tester.matchGoldenFile('media_item_page_(image)');
    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(content)');
    await tester.flingFrom(const Offset(0, 400.0), const Offset(0, -20000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(bottom)');
  });

  visualTest('${MediaItemPage}_(free_articles_warning)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetFreeArticlesLeftWarningStreamUseCase>(
          () => FakeGetFreeArticlesLeftWarningStreamUseCase(),
        );
      },
    );
    await tester.fling(find.byType(MediaItemPage), const Offset(0, -1000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(audio)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
        ],
      ),
    );
    await tester.tap(find.byType(ArticleOutputModeToggleButton));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(geoblocked)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(children: [MediaItemPageRoute(slug: '')]),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetArticleUseCase>(() => FakeGetArticleUseCase());
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(error)', (tester) async {
    final cubit = FakeMediaItemPageCubit();

    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.article.slug),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<MediaItemCubit>(() => cubit);
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest(
    '${MediaItemPage}_(more_from_brief)',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(
              slug: TestData.premiumArticleWithAudio.slug,
              briefId: TestData.currentBrief.id,
            ),
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PremiumArticleViewCubit>(() => FakePremiumArticleViewCubitFromBrief());
        },
      );

      await tester.fling(find.byType(MediaItemPage), const Offset(0, -10000), 100);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([veryHighDevice]),
  );

  visualTest(
    '${MediaItemPage}_(more_from_topic)',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(
              slug: TestData.premiumArticleWithAudio.slug,
              topicId: TestData.topic.id,
              topicSlug: TestData.topic.slug,
            ),
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PremiumArticleViewCubit>(() => FakePremiumArticleViewCubitFromTopic());
        },
      );

      await tester.fling(find.byType(MediaItemPage), const Offset(0, -10000), 100);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([veryHighDevice]),
  );
}

class FakeGetArticleUseCase extends Fake implements GetArticleUseCase {
  @override
  Future<Article> call(MediaItemArticle article, {bool refreshMetadata = false}) => throw ArticleGeoblockedException();
}

class FakeMediaItemPageCubit extends Fake implements MediaItemCubit {
  @override
  MediaItemState get state => MediaItemState.error(TestData.article);

  @override
  Stream<MediaItemState> get stream => Stream.value(MediaItemState.error(TestData.article));

  @override
  Future<void> initialize(_, __, ___, ____, _____) async {}

  @override
  Future<void> close() async {}
}

class FakePremiumArticleViewCubitFromBrief extends Fake implements PremiumArticleViewCubit {
  final _idleState = PremiumArticleViewState.idle(
    article: TestData.fullArticle,
    moreFromBriefItems: TestData.currentBrief.allEntries.map((entry) => entry.item).toList(),
    otherTopicItems: [],
    featuredCategories: List.generate(4, (index) => TestData.category),
    relatedContentItems: TestData.categoryItemList,
    enablePageSwipe: true,
  );

  PremiumArticleViewState get idleState => _idleState;

  @override
  String? get briefId => TestData.currentBrief.id;

  @override
  String? get topicId => null;

  @override
  MediaItemScrollData scrollData = MediaItemScrollData.initial();

  @override
  PremiumArticleViewState get state => idleState;

  @override
  Stream<PremiumArticleViewState> get stream => Stream.value(idleState);

  @override
  Future<void> initialize(_, __, ___, ____) async {}

  @override
  Future<void> trackReadingProgress() async {}

  @override
  void setupScrollData(_, __) {}

  @override
  void updateScrollData(_, __) {}

  @override
  Future<void> close() async {}
}

class FakePremiumArticleViewCubitFromTopic extends FakePremiumArticleViewCubitFromBrief {
  final _idleStateFromTopic = PremiumArticleViewState.idle(
    article: TestData.fullArticle,
    moreFromBriefItems: [],
    otherTopicItems: TestData.topic.entries.map<MediaItem>((entry) => entry.item).toList(),
    featuredCategories: List.generate(4, (index) => TestData.category),
    relatedContentItems: TestData.categoryItemList,
    enablePageSwipe: true,
  );

  @override
  PremiumArticleViewState get idleState => _idleStateFromTopic;

  @override
  String? get topicId => TestData.topic.id;

  @override
  String get topicTitle => TestData.topic.strippedTitle;
}

class FakeGetFreeArticlesLeftWarningStreamUseCase extends Fake implements GetFreeArticlesLeftWarningStreamUseCase {
  @override
  Stream<String> call() => TestData.freeArticlesLeftWarning != null
      ? Stream.value('This is your last free article this month.')
      : const Stream.empty();
}
