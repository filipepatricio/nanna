import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/add_interests/add_interests_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(AddInterestsPage, (tester) async {
    await tester.startApp(
      initialRoute: const AddInterestsPageRoute(),
    );

    await tester.matchGoldenFile();
  });
}
