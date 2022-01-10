import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(MediaItemPage, TestConfig.unitTesting, (tester, device) async {
    await tester.startApp();
    await tester.tap(find.byType(ReadingListCover).first);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(TopicPage), const Offset(0, -AppDimens.topicViewArticleSectionFullHeight * 2));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ArticleItemView));
    await tester.pumpAndSettle();
    await matchGoldenFile('media_item_page_(image)');
    await tester.tap(find.byType(AnimatedPointerDown));
    await tester.pumpAndSettle();
    await matchGoldenFile('media_item_page_(content)');
  });
}
