import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_background_view.dart';

import '../test_data.dart';
import 'visual_test_utils.dart';

void main() {
  visualTest(
    QuoteBackgroundView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: QuoteBackgroundView(
            article: TestData.articleMock,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: const TestConfig.stickerDevice(),
  );
}
