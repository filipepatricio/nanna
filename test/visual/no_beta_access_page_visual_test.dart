import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_beta_access/no_beta_access_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(NoBetaAccessPage, (tester) async {
    await tester.startApp(initialRoute: const NoBetaAccessPageRoute());
    await tester.matchGoldenFile();
  });
}
