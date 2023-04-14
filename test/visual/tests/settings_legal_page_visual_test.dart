import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_legal_page_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsLegalPagePage, (tester) async {
    await tester.startApp(
      initialRoute: ProfileTabGroupRouter(
        children: [
          SettingsPrivacyPolicyPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });
}
