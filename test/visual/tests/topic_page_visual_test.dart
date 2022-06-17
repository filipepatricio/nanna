import 'package:better_informed_mobile/exports.dart' as e;
import 'package:better_informed_mobile/presentation/page/topic/summary/topic_summary_section.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    TopicPage,
    (tester) async {
      await tester.startApp(
        initialRoute: e.MainPageRoute(children: [e.TopicPage(topicSlug: '')]),
      );
      await tester.matchGoldenFile('topic_page_(header)');
      await tester.dragUntilVisible(
        find.byType(TopicSummarySection),
        find.byType(TopicPage),
        const Offset(0, -25),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(summary)');

      await tester.dragUntilVisible(
        find.byKey(TopicView.bottomPaddingKey).first,
        find.byType(TopicPage),
        const Offset(0, -25),
        maxIteration: 1000,
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(articles)');
    },
  );

  visualTest(
    TopicPage,
    (tester) async {
      await tester.startApp(
        initialRoute: e.MainPageRoute(children: [e.TopicPage(topicSlug: '')]),
        dependencyOverride: (getIt) async {
          getIt.registerSingleton<AudioPlayerBannerCubit>(
            FakeAudioPlayerBannerCubit(),
          );
        },
      );
      await tester.matchGoldenFile('topic_page_(header)_(audio_banner)');

      await tester.dragUntilVisible(
        find.byType(TopicSummarySection),
        find.byType(TopicPage),
        const Offset(0, -25),
      );
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.byKey(TopicView.bottomPaddingKey).first,
        find.byType(TopicPage),
        const Offset(0, -25),
        maxIteration: 1000,
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(articles)_(audio_banner)');
    },
  );

  visualTest(
    '${TopicPage}_(error)',
    (tester) async {
      final cubit = FakeTopicPageCubit();

      await tester.startApp(
        initialRoute: e.MainPageRoute(children: [e.TopicPage(topicSlug: '')]),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<TopicPageCubit>(() => cubit);
        },
      );
      await tester.matchGoldenFile();
    },
  );
}

class FakeTopicPageCubit extends Fake implements TopicPageCubit {
  @override
  List<TargetFocus> targets = <TargetFocus>[];

  @override
  TopicPageState get state => TopicPageState.error();

  @override
  Stream<TopicPageState> get stream => Stream.value(TopicPageState.error());

  @override
  Future<void> initialize(_, __) async {}
  @override
  Future<void> initializeWithSlug(_, __) async {}
  @override
  Future<void> close() async {}

  @override
  TutorialCoachMark tutorialCoachMark(context) => TutorialCoachMark(
        context,
        targets: targets,
        paddingFocus: 0,
        opacityShadow: 0.5,
        hideSkip: true,
        onSkip: onSkipTutorialCoachMark,
      );
}
