import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(TodaysTopicsPage, TestConfig.unitTesting, (tester, device) async {
    await tester.startApp();
    await matchGoldenFile('todays_topics_page_(topic_card)');
    await tester.fling(find.byType(ReadingListCover).first, const Offset(-5000, 0), 100);
    await tester.pumpAndSettle();
    await matchGoldenFile('todays_topics_page_(relax)');
  });
}
