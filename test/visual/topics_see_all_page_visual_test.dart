import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page.dart';

import '../test_data.dart';
import 'visual_test_utils.dart';

void main() {
  visualTest(TopicsSeeAllPage, (tester) async {
    final exploreArea = TestData.exploreContent.areas.firstWhere(
      (area) => area is ExploreContentAreaTopics,
    ) as ExploreContentAreaTopics;

    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [
          TopicsSeeAllPageRoute(
            areaId: exploreArea.id,
            title: exploreArea.title,
            topics: exploreArea.topics,
          ),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });
}
