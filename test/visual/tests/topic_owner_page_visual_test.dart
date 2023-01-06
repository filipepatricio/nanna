import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    '${TopicOwnerPage}_(full_height)',
    (tester) async {
      await tester.startApp(
        initialRoute: TopicOwnerPageRoute(
          owner: TestData.topic.curationInfo.curator,
          fromTopicSlug: TestData.topic.slug,
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([highDevice]),
  );
}
