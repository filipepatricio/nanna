import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(SignInPage, (tester) async {
    await tester.startApp(initialRoute: const SignInPageRoute());
    await tester.matchGoldenFile();
  });
}
