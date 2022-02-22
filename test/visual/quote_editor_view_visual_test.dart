import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';

import 'visual_test_utils.dart';

void main() {
  final articleMock = MediaItem.article(
    id: 'id',
    slug: 'slug',
    title: 'title',
    strippedTitle: 'strippedTitle',
    type: ArticleType.premium,
    timeToRead: 0,
    publisher: Publisher(darkLogo: null, lightLogo: null, name: ''),
    sourceUrl: 'sourceUrl',
  ) as MediaItemArticle;

  visualTest(QuoteEditorView, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: 'slug'),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Container).first);
    unawaited(showQuoteEditor(context, articleMock, 'Some quote'));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile('quote_editor_view');
  });
}
