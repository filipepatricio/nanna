import 'package:better_informed_mobile/exports.dart' hide TopicPage;
import 'package:better_informed_mobile/presentation/page/explore/article_area/article_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_history_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/small_topics_area/small_topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/view_all_button.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'can navigate from explore to article',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());
      await tester.drag(find.byType(ExplorePage), const Offset(0, -1000));

      await tester.pumpAndSettle();
      final articleCoverFinder = find.descendant(
        of: find.byType(ArticleAreaView),
        matching: find.bySubtype<ArticleCover>(),
      );

      await tester.ensureVisible(articleCoverFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(articleCoverFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(MediaItemPage), findsOneWidget);
    },
  );

  testWidgets(
    'can navigate from explore to topic',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());

      final topicCoverFinder = find.descendant(
        of: find.byType(SmallTopicsAreaView),
        matching: find.bySubtype<TopicCover>(),
      );

      expect(topicCoverFinder, findsNWidgets(3));
      await tester.ensureVisible(topicCoverFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(topicCoverFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(TopicPage), findsOneWidget);
    },
  );

  testWidgets(
    'can navigate from explore to pill',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());
      expect(find.byType(InformedPill), findsAtLeastNWidgets(8));
      await tester.tap(find.byType(InformedPill).last);
      await tester.pumpAndSettle();
      expect(find.byType(CategoryPage), findsOneWidget);
    },
  );

  testWidgets(
    'can navigate from explore to see all',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());

      final topicsAreaFinder = find.byType(SmallTopicsAreaView);
      await tester.ensureVisible(topicsAreaFinder);
      await tester.pumpAndSettle();

      final viewAllButtonFinder = find.descendant(
        of: topicsAreaFinder,
        matching: find.byType(ViewAllButton),
      );

      await tester.dragUntilVisible(viewAllButtonFinder, topicsAreaFinder, const Offset(-5000, 0));
      await tester.pumpAndSettle();

      await tester.tap(viewAllButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TopicsSeeAllPage), findsOneWidget);
    },
  );

  testWidgets(
    'can see search results and search history',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());
      expect(find.byType(SearchHistoryView), findsNothing);
      await tester.enterText(find.byType(TextFormField), 'world');
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.byType(SearchView), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextFormField));
      expect(find.byType(ExplorePage), findsOneWidget);
    },
  );

  testWidgets(
    'can search results, enter article, go back and see search view',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());
      expect(find.byType(SearchHistoryView), findsNothing);
      await tester.enterText(find.byType(TextFormField), 'world');
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.byType(SearchView), findsOneWidget);
      final articleCoverFinder = find.descendant(
        of: find.byType(SearchView),
        matching: find.bySubtype<ArticleCover>(),
      );
      await tester.tap(articleCoverFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SearchView), findsOneWidget);
    },
  );
}
