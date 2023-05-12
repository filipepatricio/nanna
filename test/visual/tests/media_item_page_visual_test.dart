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
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../flutter_test_config.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${MediaItemPage}_(no_image)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: TestData.premiumArticleWithoutImage.slug,
            openedFrom: l10n.main_todayTab,
          ),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(image)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: TestData.premiumArticleWithAudio.slug,
            openedFrom: l10n.main_todayTab,
          ),
        ],
      ),
    );

    await tester.matchGoldenFile();
    await tester.drag(find.byType(PremiumArticleView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(content)');
  });

  visualTest('${MediaItemPage}_(free_articles_warning)', (tester) async {
    final useCase = MockGetFreeArticlesLeftWarningStreamUseCase();
    when(useCase.call()).thenAnswer((_) => Stream.value(TestData.freeArticlesLeftWarning));

    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: TestData.premiumArticleWithAudio.slug,
            openedFrom: l10n.main_exploreTab,
          ),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetFreeArticlesLeftWarningStreamUseCase>(() => useCase);
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(geoblocked)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: '',
            openedFrom: l10n.main_todayTab,
          )
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetArticleUseCase>(() => FakeGetArticleUseCase());
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(error)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: TestData.article.slug,
            openedFrom: l10n.main_todayTab,
          ),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<MediaItemCubit>(() => FakeMediaItemCubit());
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(offline)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: TestData.article.slug,
            openedFrom: l10n.main_exploreTab,
          ),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<MediaItemCubit>(
          () => FakeMediaItemCubit(
            state: MediaItemState.offline(article: TestData.article),
          ),
        );
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

      await tester.fling(find.byType(PremiumArticleView), const Offset(0, -10000), 100);
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

      await tester.fling(find.byType(PremiumArticleView), const Offset(0, -10000), 100);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([veryHighDevice]),
  );
}

class FakeGetArticleUseCase extends Fake implements GetArticleUseCase {
  @override
  Future<Article> single(MediaItemArticle article) => throw ArticleGeoblockedException();
}

class FakeMediaItemCubit extends Fake implements MediaItemCubit {
  FakeMediaItemCubit({
    MediaItemState? state,
  }) : _state = state ?? MediaItemState.error(TestData.article);

  final MediaItemState _state;

  @override
  MediaItemState get state => _state;

  @override
  Stream<MediaItemState> get stream => Stream.value(_state);

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
    preferredArticleTextScaleFactor: 1.0,
    showTextScaleFactorSelector: true,
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
    preferredArticleTextScaleFactor: 1.0,
    showTextScaleFactorSelector: true,
  );

  @override
  PremiumArticleViewState get idleState => _idleStateFromTopic;

  @override
  String? get topicId => TestData.topic.id;

  @override
  String get topicTitle => TestData.topic.strippedTitle;
}
