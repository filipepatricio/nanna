import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/share_quote_view.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  const quote = 'Lorem ipsum dolor sit amet, '
      'consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. '
      'Cum sociis natoque penatibus et ma...';

  visualTest(
    ShareQuoteCombinedView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: ShareQuoteCombinedView(
            quote: quote,
            article: TestData.article,
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([shareImage]),
  );
}
