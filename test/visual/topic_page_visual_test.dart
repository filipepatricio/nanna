import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  group(TopicPage, () {
    visualTest(TopicPage, TestConfig.unitTesting.withDevices([veryHighDevice]), (tester, device) async {
      await tester.startApp();
      await tester.tap(find.byType(ReadingListCover).first);
      await tester.pumpAndSettle();
      await matchGoldenFile('topic_page_(high_device)');
      // TODO: Fix running with multiple devices at once to remove this skip
    }, skip: true);

    visualTest('$TopicPage in normal screens', TestConfig.unitTesting, (tester, device) async {
      await tester.startApp();
      await tester.tap(find.byType(ReadingListCover).first);
      await tester.pumpAndSettle();
      await matchGoldenFile('topic_page_(header)');
      await tester.drag(find.byType(TopicPage), const Offset(0, -AppDimens.topicViewArticleSectionFullHeight));
      await tester.pumpAndSettle();
      await matchGoldenFile('topic_page_(summary)');
      await tester.drag(find.byType(TopicPage), const Offset(0, -AppDimens.topicViewArticleSectionFullHeight));
      await tester.pumpAndSettle();
      await matchGoldenFile('topic_page_(articles)');
    });
  });
}
