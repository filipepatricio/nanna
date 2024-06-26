import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_text_size_selector_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/media/article_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article_text_scale_factor_selector_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_categories.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
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
        matching: find.byType(PaddingTapWidget),
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
        matching: find.byType(PaddingTapWidget),
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
      expect(find.byText(l10n.topic_label), findsOneWidget);
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
      expect(find.byText(l10n.topic_label), findsNothing);
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
            matching: find.byType(InformedPill),
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

  testWidgets('closing page that was opened through deeplink does not throw', (widgetTester) async {
    await widgetTester.startApp(
      initialRoute: const MainPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<PremiumArticleViewCubit>(() => FakePremiumArticleViewCubit());
      },
    );

    final navigator = AutoRouter.of(find.byType(MainPage).evaluate().single);
    navigator.navigateNamed('${const MainPageRoute().path}/articles/${TestData.premiumArticleWithAudio.slug}').ignore();
    await widgetTester.pumpAndSettle();

    expect(find.byType(MediaItemPage), findsOneWidget);

    await widgetTester.tap(find.byType(BackTextButton));
    await widgetTester.pumpAndSettle();

    expect(find.byType(MediaItemPage), findsNothing);
  });

  testWidgets(
    'text size selector is shown if flag is true',
    (tester) async {
      final useCase = MockShouldUseTextSizeSelectorUseCase();
      when(useCase()).thenAnswer((_) async => true);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ShouldUseTextSizeSelectorUseCase>(() => useCase);
        },
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );

      expect(find.byKey(articleTextScaleFactorSelectorButtonKey), findsOneWidget);
      await tester.tap(find.byKey(articleTextScaleFactorSelectorButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(ArticleTextScaleFactorSelectorPage), findsOneWidget);
    },
  );

  testWidgets(
    'text size selector is not shown if flag is false',
    (tester) async {
      final useCase = MockShouldUseTextSizeSelectorUseCase();
      when(useCase()).thenAnswer((_) async => false);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ShouldUseTextSizeSelectorUseCase>(() => useCase);
        },
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );

      expect(find.byKey(articleTextScaleFactorSelectorButtonKey), findsNothing);
    },
  );
}

class FakeBookmarkButtonCubit extends Fake implements BookmarkButtonCubit {
  @override
  BookmarkButtonState get state => BookmarkButtonState.idle(
        const BookmarkTypeData.article('', '', ArticleType.premium),
        BookmarkState.notBookmarked(),
      );

  @override
  Stream<BookmarkButtonState> get stream => Stream.value(
        BookmarkButtonState.idle(
          const BookmarkTypeData.article('', '', ArticleType.premium),
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
    preferredArticleTextScaleFactor: 1.0,
    showTextScaleFactorSelector: true,
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
