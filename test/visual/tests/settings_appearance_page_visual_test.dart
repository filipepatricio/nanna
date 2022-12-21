import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/appearance/settings_appearance_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsAppearancePage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsAppearancePageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });
}
