import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(SettingsAccountPage, (tester) async {
    await tester.startApp(initialRoute: const SettingsAccountPageRoute());
    await tester.matchGoldenFile();
  });
}
