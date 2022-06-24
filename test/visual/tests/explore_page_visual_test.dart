import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
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
    testConfig: TestConfig.withDevices([veryHighDevice]),
  );

  visualTest(
    '${ExplorePage}_(error)',
    (tester) async {
      final cubit = FakeExplorePageCubit();

      await tester.startApp(
        initialRoute: const ExploreTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ExplorePageCubit>(() => cubit);
        },
      );
      await tester.matchGoldenFile();
    },
  );
}

class FakeExplorePageCubit extends Fake implements ExplorePageCubit {
  @override
  ExplorePageState get state => ExplorePageState.error();

  @override
  Stream<ExplorePageState> get stream => Stream.value(ExplorePageState.error());

  @override
  Future<void> initialize() async {}
  @override
  Future<void> close() async {}
}
