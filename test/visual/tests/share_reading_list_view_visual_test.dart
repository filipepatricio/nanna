import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_reading_list_view.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    ShareReadingListView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareReadingListView(
            topic: TestData.topic,
            articles: TestData.topic.readingList.entries.map((e) => e.item as MediaItemArticle).toList(),
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([shareImage]),
  );
}
