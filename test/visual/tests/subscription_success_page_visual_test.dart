import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_success_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest('${SubscriptionSuccessPage}_(trial)', (tester) async {
    await tester.startApp(initialRoute: SubscriptionSuccessPageRoute(trialDays: 7, reminderDays: 3));
    await tester.matchGoldenFile();
  });

  visualTest('${SubscriptionSuccessPage}_(no_trial)', (tester) async {
    await tester.startApp(
      initialRoute: SubscriptionSuccessPageRoute(trialDays: 0, reminderDays: 0),
    );
    await tester.matchGoldenFile();
  });
}
