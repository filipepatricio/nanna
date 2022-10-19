import 'dart:async';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(QuoteEditorView, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(children: [MediaItemPageRoute(slug: '')]),
    );

    await tester.drag(find.byType(PremiumArticleView), const Offset(0, -2000));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(MediaItemPage).first);
    unawaited(showQuoteEditor(context, TestData.article, 'Some quote'));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
