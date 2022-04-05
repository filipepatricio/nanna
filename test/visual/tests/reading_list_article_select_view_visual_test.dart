import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(ReadingListArticlesSelectView, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(children: [TopicPage(topicSlug: '')]),
    );
    await tester.tap(find.byKey(const Key('share-topic-button')));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });
}
