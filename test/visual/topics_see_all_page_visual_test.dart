import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page.dart';

import '../test_data.dart';
import 'visual_test_utils.dart';

void main() {
  visualTest(TopicsSeeAllPage, (tester) async {
    final area = TestData.exploreContent.areas.firstWhere(
      (area) => area is ExploreContentAreaTopics,
    ) as ExploreContentAreaTopics;

    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [TopicsSeeAllPageRoute(areaId: area.id, title: area.title, topics: area.topics)],
      ),
    );
    await tester.matchGoldenFile();
  });
}
