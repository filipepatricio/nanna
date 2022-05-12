import 'package:better_informed_mobile/domain/feature_flags/use_case/show_pills_on_explore_page_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ExplorePage, (tester) async {
    await tester.startApp(
      initialRoute: const ExploreTabGroupRouter(
        children: [
          ExplorePageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${ExplorePage}_(search)', (tester) async {
    await tester.startApp(
      initialRoute: const ExploreTabGroupRouter(
        children: [
          ExplorePageRoute(),
        ],
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'world');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${ExplorePage}_(with_pills)', (tester) async {
    await tester.startApp(
      initialRoute: const ExploreTabGroupRouter(
        children: [
          ExplorePageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<ShowPillsOnExplorePageUseCase>(
          FakeShowPillsOnExplorePageUseCase(),
        );
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest(
    '${ExplorePage}_(full_height)',
    (tester) async {
      await tester.startApp(
        initialRoute: const ExploreTabGroupRouter(
          children: [
            ExplorePageRoute(),
          ],
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([veryHighDevice]),
  );
}
