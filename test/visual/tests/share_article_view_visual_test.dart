import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    ShareArticleView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareArticleView(
            article: TestData.article,
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([shareImage]),
  );
}
