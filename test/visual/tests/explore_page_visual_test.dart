import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../../test_data.dart';
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
    '${ExplorePage}_(full_height_visited)',
    (tester) async {
      await tester.startApp(
        initialRoute: const ExploreTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ExplorePageCubit>(
            () => FakeExplorePageCubitVisited(),
          );
        },
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([veryHighDevice]),
  );

  visualTest(
    '${ExplorePage}_(error)',
    (tester) async {
      final cubit = FakeErrorExplorePageCubit();

      await tester.startApp(
        initialRoute: const ExploreTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ExplorePageCubit>(() => cubit);
        },
      );
      await tester.matchGoldenFile();
    },
  );

  visualTest(
    '${ExplorePage}_(tutorial_snack_bar)',
    (tester) async {
      await tester.startApp(
        initialRoute: const ExploreTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<IsTutorialStepSeenUseCase>(
            () => FakeIsTutorialStepSeenUseCase(isStepSeen: false),
          );
        },
      );
      await tester.matchGoldenFile();
      await tester.pumpAndSettle(const Duration(seconds: 5));
    },
  );
}

class FakeErrorExplorePageCubit extends Fake implements ExplorePageCubit {
  @override
  ExplorePageState get state => ExplorePageState.error(
        LocaleKeys.common_error_title.tr(),
        LocaleKeys.common_error_body.tr(),
      );

  @override
  Stream<ExplorePageState> get stream => Stream.value(
        ExplorePageState.error(
          LocaleKeys.common_error_title.tr(),
          LocaleKeys.common_error_body.tr(),
        ),
      );

  @override
  Future<void> initialize() async {}
  @override
  Future<void> close() async {}
}

class FakeExplorePageCubitVisited extends Fake implements ExplorePageCubit {
  final _state = ExplorePageState.idle([
    ExploreItem.pills([TestData.categoryWithItems]),
    ...TestData.exploreContentVisited.areas.map(ExploreItem.stream).toList(),
  ]);

  @override
  ExplorePageState get state => _state;

  @override
  Stream<ExplorePageState> get stream => Stream.value(_state);

  @override
  Future<void> initialize() async {}
  @override
  Future<void> close() async {}
}
