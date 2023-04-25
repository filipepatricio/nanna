import 'dart:async';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/empty_page.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(AppUpdateChecker, (tester) async {
    await tester.startApp(initialRoute: const EmptyPageRoute());

    final context = tester.element(find.byType(EmptyPage).first);
    unawaited(
      InformedDialog.showAppUpdate(
        context,
        availableVersion: '2.0.0',
        onWillPop: () async => true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
