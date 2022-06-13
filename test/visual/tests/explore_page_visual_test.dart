import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest('${ExplorePage}_(search)', (tester) async {
    await tester.startApp(initialRoute: const ExploreTabGroupRouter());
    await tester.enterText(find.byType(TextFormField), 'world');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${ExplorePage}_(searchHistory)', (tester) async {
    await tester.startApp(initialRoute: const ExploreTabGroupRouter());
    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest(
    '${ExplorePage}_(full_height)',
    (tester) async {
      await tester.startApp(initialRoute: const ExploreTabGroupRouter());
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([veryHighDevice]),
  );
}
