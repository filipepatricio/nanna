import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_success_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest('${SubscriptionSuccessPage}_(trial)', (tester) async {
    await tester.startApp(initialRoute: SubscriptionSuccessPageRoute(trialMode: true));
    await tester.matchGoldenFile();
  });

  visualTest('${SubscriptionSuccessPage}_(no_trial)', (tester) async {
    await tester.startApp(
      initialRoute: SubscriptionSuccessPageRoute(trialMode: false),
    );
    await tester.matchGoldenFile();
  });
}
