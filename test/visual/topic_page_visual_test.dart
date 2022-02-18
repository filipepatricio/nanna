import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/summary/topic_summary_section.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(
    TopicPage,
    (tester) async {
      await tester.startApp();
      await tester.tap(find.byType(ReadingListCover).first);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(header)');
      await tester.dragUntilVisible(
        find.byType(TopicSummarySection),
        find.byType(TopicPage),
        const Offset(0, -25),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(summary)');
      await tester.dragUntilVisible(
        find.byType(ArticleItemView).last,
        find.byType(TopicPage),
        const Offset(0, -10),
        maxIteration: 1000,
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(articles)');
    },
  );
}
