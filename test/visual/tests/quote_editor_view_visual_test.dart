import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(QuoteEditorView, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(children: [MediaItemPageRoute(slug: '')]),
    );
    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Container).first);
    unawaited(showQuoteEditor(context, TestData.article, 'Some quote'));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
