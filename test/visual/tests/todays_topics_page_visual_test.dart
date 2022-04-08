import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/round_topic_cover_large.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(TodaysTopicsPage, (tester) async {
    await tester.startApp();
    await tester.matchGoldenFile('todays_topics_page_(topic_card)');
    await tester.fling(find.byType(RoundTopicCoverLarge).first, const Offset(0, -10000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('todays_topics_page_(relax)');
  });
}