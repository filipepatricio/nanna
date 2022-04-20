import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(InviteFriendPage, (tester) async {
    await tester.startApp(initialRoute: const InviteFriendPageRoute());
    await tester.matchGoldenFile();
  });
}
