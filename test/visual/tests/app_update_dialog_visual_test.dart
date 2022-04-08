import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upgrader/upgrader.dart';

import '../visual_test_utils.dart';

void main() {
  setUp(() => Upgrader().debugDisplayAlways = true);

  visualTest(AppUpdateChecker, (tester) async {
    await tester.startApp();
    await tester.matchGoldenFile();
  });

  tearDown(() => Upgrader().debugDisplayAlways = false);
}
