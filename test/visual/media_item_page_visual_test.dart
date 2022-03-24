import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/round_topic_cover_large.dart';
import 'package:better_informed_mobile/presentation/widget/selected_articles_label.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(MediaItemPage, (tester) async {
    await tester.startApp();
    await tester.tap(find.byType(RoundTopicCoverLarge).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SelectedArticlesLabel).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ArticleEditorsNote).first);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(image)');
    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(content)');
  });
}
