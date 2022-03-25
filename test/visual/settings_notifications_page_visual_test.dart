import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(SettingsNotificationsPage, (tester) async {
    await tester.startApp(initialRoute: const SettingsNotificationsPageRoute());
    await tester.matchGoldenFile();
  });
}
