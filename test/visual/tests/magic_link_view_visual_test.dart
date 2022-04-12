import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/magic_link_view.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(MagicLinkContent, (tester) async {
    await tester.startApp(initialRoute: const SignInPageRoute());
    await tester.enterText(find.byType(EmailInput), 'me@example.io');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });
}
