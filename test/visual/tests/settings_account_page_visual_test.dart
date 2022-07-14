import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsAccountPage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsAccountPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
    await tester.tap(find.byType(DeleteAccountLink));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('settings_account_page_(delete_account)');
  });
}
