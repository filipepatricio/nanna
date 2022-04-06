import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_actions_bar.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(MediaItemPage, (tester) async {
    await tester.startApp(initialRoute: MainPageRoute(children: [MediaItemPageRoute(slug: '')]));
    await tester.matchGoldenFile('media_item_page_(image)');
    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(content)');
  });

  visualTest('${MediaItemPage}_audio_view', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: MockDTO.premiumMediaItemArticleWithAudio.slug),
        ],
      ),
    );
    await tester.tap(find.byType(AudioButton));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });
}
