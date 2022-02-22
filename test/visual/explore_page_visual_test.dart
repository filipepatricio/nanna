import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(ExplorePage, (tester) async {
    await tester.startApp(initialRoute: const ExploreTabGroupRouter(children: [ExplorePageRoute()]));
    await tester.matchGoldenFile();
  });
}
