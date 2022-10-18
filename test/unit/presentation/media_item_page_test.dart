import 'package:better_informed_mobile/data/audio/audio_repository_mock.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pill.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_categories.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../finders.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'media item page has not premium audio view if article doesnt have audio version',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: ''),
          ],
        ),
      );
      expect(find.byType(PremiumArticleView), findsOneWidget);
      expect(find.byType(PremiumArticleAudioView), findsNothing);
    },
  );

  testWidgets(
    'media item page has premium audio view if article hasAudioVersion',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );

      await tester.fling(find.byType(PremiumArticleView), const Offset(-2000, 0), 100);
      await tester.pumpAndSettle();
      expect(find.byType(PremiumArticleAudioView), findsOneWidget);
    },
  );

  testWidgets(
    'pressing play button changes the state',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      await tester.fling(find.byType(PremiumArticleView), const Offset(-2000, 0), 100);
      await tester.pumpAndSettle();

      final playButton = find.byType(AudioControlButton);
      expect(playButton, findsOneWidget);
      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: playButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.playArrow,
      );
      await tester.tap(playButton);
      await tester.pumpAndSettle();

      final pauseButton = find.byType(AudioControlButton);
      expect(pauseButton, findsOneWidget);
      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: playButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.pause,
      );
    },
  );

  testWidgets(
    'article is not bookmarked',
    (tester) async {
      final BookmarkButtonCubit cubit = FakeBookmarkButtonCubit();

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<BookmarkButtonCubit>(() => cubit);
        },
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      final bookmarkButton = find.descendant(
        of: find.byType(BookmarkButton),
        matching: find.byType(ExpandTapWidget),
      );
      expect(bookmarkButton, findsOneWidget);

      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: bookmarkButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.bookmarkOutline,
      );
    },
  );

  testWidgets(
    'article is bookmarked',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      final bookmarkButton = find.descendant(
        of: find.byType(BookmarkButton),
        matching: find.byType(ExpandTapWidget),
      );
      expect(bookmarkButton, findsOneWidget);

      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: bookmarkButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.bookmarkFilled,
      );
    },
  );

  testWidgets(
    'media item page has topic overview label if opened from a topic',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(
              topicId: TestData.topic.id,
              slug: TestData.premiumArticleWithAudio.slug,
            ),
          ],
        ),
      );
      expect(find.byText(LocaleKeys.article_topicOverview.tr()), findsOneWidget);
    },
  );

  testWidgets(
    'media item page does not have topic overview label if not opened from a topic',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      expect(find.byText(LocaleKeys.article_topicOverview.tr()), findsNothing);
    },
  );

  testWidgets(
    'can navigate from related content to explore',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PremiumArticleViewCubit>(() => FakePremiumArticleViewCubit());
        },
      );

      expect(find.byType(ExplorePage), findsNothing);

      final goToExploreFinder = find.descendant(
        of: find.byType(RelaxView),
        matching: find.byType(GestureDetector),
      );

      await tester.fling(find.byType(MediaItemPage), const Offset(0, -20000), 100);

      await tester.pumpAndSettle();
      expect(goToExploreFinder, findsOneWidget);
      await tester.tap(goToExploreFinder);
      await tester.pumpAndSettle();

      expect(find.byType(ExplorePage), findsOneWidget);
    },
  );
  testWidgets(
    'can navigate from related content to category',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PremiumArticleViewCubit>(() => FakePremiumArticleViewCubit());
        },
      );

      final categoryPillFinder = find
          .descendant(
            of: find.byType(RelatedCategories),
            matching: find.byType(ExplorePill),
          )
          .first;

      await tester.dragUntilVisible(
        find.byType(RelatedCategories, skipOffstage: false),
        find.byType(MediaItemPage),
        const Offset(0, -100),
      );

      await tester.pumpAndSettle();
      expect(categoryPillFinder, findsOneWidget);
      await tester.tap(categoryPillFinder);
      await tester.pumpAndSettle();

      expect(find.byType(CategoryPage), findsOneWidget);
    },
  );

  testWidgets(
    'check if the audio position is properly loaded',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(
              article: TestData.premiumArticleWithAudio,
            ),
          ],
        ),
      );

      await tester.fling(find.byType(PremiumArticleView), const Offset(-2000, 0), 100);
      await tester.pumpAndSettle();

      expect(find.byType(PremiumArticleAudioView), findsOneWidget);

      final progressBar = tester.widget<ActiveProgressBar>(find.byType(ActiveProgressBar).first);

      expect(progressBar.position.inSeconds, mockAudioPosition.inSeconds);
    },
  );
}

class FakeBookmarkButtonCubit extends Fake implements BookmarkButtonCubit {
  @override
  BookmarkButtonState get state => BookmarkButtonState.idle(
        const BookmarkTypeData.article('', ''),
        BookmarkState.notBookmarked(),
      );

  @override
  Stream<BookmarkButtonState> get stream => Stream.value(
        BookmarkButtonState.idle(
          const BookmarkTypeData.article('', ''),
          BookmarkState.notBookmarked(),
        ),
      );

  @override
  Future<void> initialize(BookmarkTypeData data) async {}

  @override
  Future<void> close() async {}
}

class FakePremiumArticleViewCubit extends Fake implements PremiumArticleViewCubit {
  final idleState = PremiumArticleViewState.idle(
    article: TestData.fullArticle,
    moreFromBriefItems: TestData.currentBrief.allEntries.map((entry) => entry.item).toList(),
    otherTopicItems: [],
    featuredCategories: List.generate(4, (index) => TestData.category),
    relatedContentItems: TestData.categoryItemList,
    enablePageSwipe: true,
  );

  @override
  String? get briefId => TestData.currentBrief.id;

  @override
  String? get topicId => TestData.topic.id;

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
  void updateScrollData(_, __) {}

  @override
  void onRelatedContentItemTap(_) {}

  @override
  void onRelatedCategoryTap(_) {}

  @override
  void onMoreFromBriefItemTap(_) {}

  @override
  void onOtherTopicItemTap(_) {}

  @override
  Future<void> close() async {}
}
