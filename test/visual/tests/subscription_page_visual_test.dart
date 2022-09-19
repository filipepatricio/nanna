import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SubscriptionPage, (tester) async {
    await tester.startApp(initialRoute: const SubscriptionPageRoute());
    await tester.matchGoldenFile();
  });
}
