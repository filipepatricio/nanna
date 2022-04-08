import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(
    TopicOwnerPage,
    (tester) async {
      await tester.startApp(initialRoute: TopicPage(topicSlug: ''));
      await tester.tap(find.byType(TopicOwnerAvatar).last);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([const Device(name: 'full_screen', size: Size(375, 1200))]),
  );
}
