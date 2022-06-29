import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(DailyBriefPage, (tester) async {
    await tester.startApp();
    await tester.matchGoldenFile();
    await tester.fling(find.byType(TopicCover).first, const Offset(0, -20000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('daily_brief_page_(relax)');
  });

  visualTest(
    '${DailyBriefPage}_(full_height)',
    (tester) async {
      await tester.startApp();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.withDevices([veryHighDevice]),
  );

  visualTest('${DailyBriefPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          FakeAudioPlayerBannerCubit(),
        );
      },
    );
    await tester.fling(find.byType(TopicCover).first, const Offset(0, -10000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest(
    '${DailyBriefPage}_(error)',
    (tester) async {
      final cubit = FakeDailyBriefPageCubit();

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(() => cubit);
        },
      );
      await tester.matchGoldenFile();
    },
  );
}

class FakeDailyBriefPageCubit extends Fake implements DailyBriefPageCubit {
  @override
  DailyBriefPageState get state => DailyBriefPageState.error();

  @override
  Stream<DailyBriefPageState> get stream => Stream.value(DailyBriefPageState.error());

  @override
  Future<void> initialize() async {}
  @override
  Future<void> close() async {}

  @override
  TutorialCoachMark tutorialCoachMark(BuildContext context) => TutorialCoachMark(context, targets: <TargetFocus>[]);
}
