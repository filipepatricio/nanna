import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsManageMyInterestsPage, (tester) async {
    await tester.startApp(initialRoute: const SettingsManageMyInterestsPageRoute());
    await tester.matchGoldenFile();
  });
}
