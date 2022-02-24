import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_member_access/no_member_access_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(NoMemberAccessPage, (tester) async {
    await tester.startApp(initialRoute: const NoMemberAccessPageRoute());
    await tester.matchGoldenFile();
  });
}
