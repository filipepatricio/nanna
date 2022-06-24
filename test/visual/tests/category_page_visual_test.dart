import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(CategoryPage, (tester) async {
    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [
          CategoryPageRoute(
            category: TestData.category,
          ),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });
}
