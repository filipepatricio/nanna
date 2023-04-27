import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/article_text_scale_factor_selector_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ArticleTextScaleFactorSelectorPage, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
        ],
      ),
    );

    await tester.tap(find.byKey(articleTextScaleFactorSelectorButtonKey));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });
}
