import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(ProfilePage, (tester, device) async {
    await tester.startApp(initialRoute: const ProfileTabGroupRouter(children: [ProfilePageRoute()]));
    await matchGoldenFile();
  });
}
