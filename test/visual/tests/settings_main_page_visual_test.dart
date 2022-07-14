import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsMainPage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsMainPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });
}
