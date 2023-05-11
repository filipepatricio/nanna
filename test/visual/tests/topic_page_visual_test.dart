import 'package:better_informed_mobile/exports.dart' as e;
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../fakes.dart';
import '../../flutter_test_config.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    TopicPage,
    (tester) async {
      await tester.startApp(
        initialRoute: e.MainPageRoute(
          children: [
            e.TopicPage(
              topicSlug: '',
              openedFrom: l10n.main_todayTab,
            )
          ],
        ),
      );
      await tester.matchGoldenFile('topic_page_(header)');

      await tester.fling(find.byType(TopicPage), const Offset(0, -700), 100);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(summary)');

      await tester.fling(find.byType(TopicPage), const Offset(0, -4000), 100);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(articles)');
    },
  );

  visualTest(
    TopicPage,
    (tester) async {
      await tester.startApp(
        initialRoute: e.MainPageRoute(
          children: [
            e.TopicPage(
              topicSlug: '',
              openedFrom: l10n.main_todayTab,
            )
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerSingleton<AudioPlayerBannerCubit>(
            FakeAudioPlayerBannerCubit(),
          );
        },
      );
      await tester.matchGoldenFile('topic_page_(header)_(audio_banner)');

      await tester.fling(find.byType(TopicPage), const Offset(0, -4000), 100);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('topic_page_(articles)_(audio_banner)');
    },
  );

  visualTest(
    '${TopicPage}_(error)',
    (tester) async {
      final cubit = FakeTopicPageCubit();

      await tester.startApp(
        initialRoute: e.MainPageRoute(
          children: [
            e.TopicPage(
              topicSlug: '',
              openedFrom: l10n.main_exploreTab,
            )
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<TopicPageCubit>(() => cubit);
        },
      );
      await tester.matchGoldenFile();
    },
  );

  visualTest(
    '${TopicPage}_(share)',
    (tester) async {
      await tester.startApp(
        initialRoute: e.MainPageRoute(
          children: [
            e.TopicPage(
              topicSlug: '',
              openedFrom: l10n.main_exploreTab,
            )
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerSingleton<AudioPlayerBannerCubit>(
            FakeAudioPlayerBannerCubit(),
          );
        },
      );

      await tester.tap(find.byKey(const Key('share-topic-button')));
      await tester.pumpAndSettle();
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
}
