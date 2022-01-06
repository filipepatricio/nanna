import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(TopicPage, TestConfig.unitTesting, (tester, device) async {
    await tester.startApp();
    await tester.tap(find.byType(ReadingListCover).first);
    await tester.pumpAndSettle();
    await matchGoldenFile();
  });
}
