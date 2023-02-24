import 'dart:async';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/empty_page.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(ShareOptionsView, (tester) async {
    await tester.startApp(initialRoute: const EmptyPageRoute());

    final context = tester.element(find.byType(EmptyPage).first);
    unawaited(showShareOptions(context));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
