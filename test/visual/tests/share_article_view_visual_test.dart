import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_background_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    ShareArticleStickerView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareArticleStickerView(
            article: TestData.article,
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([shareSticker]),
  );

  visualTest(
    ShareArticleBackgroundView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareArticleBackgroundView(
            article: TestData.article,
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([shareImage]),
  );

  visualTest(
    ShareArticleCombinedView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareArticleCombinedView(
            article: TestData.article,
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([shareImage]),
  );
}
