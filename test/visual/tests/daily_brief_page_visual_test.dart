import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/brief_entry_cover/brief_entry_cover.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../fakes.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(DailyBriefPage, (tester) async {
    await tester.startApp();
    await tester.matchGoldenFile();
    await tester.fling(find.byType(BriefEntryCover).first, const Offset(0, -20000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('daily_brief_page_(relax)');
  });

  visualTest(
    '${DailyBriefPage}_(full_height)',
    (tester) async {
      await tester.startApp();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([ultraHighDevice]),
  );

  visualTest(
    '${DailyBriefPage}_(full_height_visited)',
    (tester) async {
      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(
            () => FakeDailyBriefPageCubitVisited(),
          );
        },
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([ultraHighDevice]),
  );

  visualTest('${DailyBriefPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          FakeAudioPlayerBannerCubit(),
        );
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest(
    '${DailyBriefPage}_(error)',
    (tester) async {
      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(
            () => FakeDailyBriefPageCubit(),
          );
        },
      );
      await tester.matchGoldenFile();
    },
  );

  visualTest(
    '${DailyBriefPage}_(offline)',
    (tester) async {
      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(
            () => FakeDailyBriefPageCubit(
              state: DailyBriefPageState.offline(),
            ),
          );
        },
      );
      await tester.matchGoldenFile();
    },
  );

  visualTest(
    '${DailyBriefPage}_(tutorial_snack_bar)',
    (tester) async {
      await tester.startApp(
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

  visualTest(
    '${DailyBriefPage}_(calendar)',
    (tester) async {
      await withClock(
        Clock(() => DateTime(2022, 07, 14)),
        () async {
          await tester.startApp();

          await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
          await tester.pumpAndSettle();

          await tester.matchGoldenFile();
        },
      );
    },
  );

  visualTest(
    '${DailyBriefPage}_(calendar_with_title)',
    (tester) async {
      await withClock(
        Clock(() => DateTime(2022, 07, 14)),
        () async {
          await tester.startApp();

          await tester.fling(find.byType(DailyBriefPage).first, const Offset(0, -20000), 100);
          await tester.pumpAndSettle();

          await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).last));
          await tester.pumpAndSettle();

          await tester.matchGoldenFile();
        },
      );
    },
  );
}

class FakeDailyBriefPageCubit extends Fake implements DailyBriefPageCubit {
  FakeDailyBriefPageCubit({
    DailyBriefPageState? state,
  }) : _state = state ?? DailyBriefPageState.error();

  final DailyBriefPageState _state;

  @override
  DailyBriefPageState get state => _state;

  @override
  Stream<DailyBriefPageState> get stream => Stream.value(state);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> close() async {}

  @override
  TutorialCoachMark tutorialCoachMark() => TutorialCoachMark(targets: <TargetFocus>[]);
}

class FakeDailyBriefPageCubitVisited extends Fake implements DailyBriefPageCubit {
  final _state = DailyBriefPageState.idle(
    selectedBrief: TestData.currentBriefVisited,
    pastDays: BriefPastDays.empty(),
    showCalendar: false,
    showAppBarTitle: false,
  );

  @override
  DailyBriefPageState get state => _state;

  @override
  Stream<DailyBriefPageState> get stream => Stream.value(_state);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> initializeTutorialSnackBar() async {}

  @override
  Future<void> initializeTutorialCoachMark() async {}

  @override
  TutorialCoachMark tutorialCoachMark() => TutorialCoachMark(targets: <TargetFocus>[]);
}
