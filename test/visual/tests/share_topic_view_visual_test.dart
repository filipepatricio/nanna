import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_topic_view.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    ShareTopicStickerView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareTopicStickerView(topic: TestData.topic.asPreview),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices(
      [
        shareSticker,
      ],
    ),
  );

  visualTest(
    ShareTopicBackgroundView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareTopicBackgroundView(topic: TestData.topic.asPreview),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices(
      [
        shareImage,
      ],
    ),
  );

  visualTest(
    ShareTopicCombinedView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareTopicCombinedView(topic: TestData.topic.asPreview),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices(
      [
        shareImage,
      ],
    ),
  );
}
