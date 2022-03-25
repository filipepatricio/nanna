import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(ProfilePage, (tester) async {
    await tester.startApp(initialRoute: const ProfileTabGroupRouter(children: [ProfilePageRoute()]));
    await tester.matchGoldenFile();
  });
}
