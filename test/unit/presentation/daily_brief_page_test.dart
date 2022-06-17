import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart' hide TopicPage;
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../finders.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';
import 'daily_brief_page_test.mocks.dart';

@GenerateMocks(
  [
    GetCurrentBriefUseCase,
    IsTutorialStepSeenUseCase,
    SetTutorialStepSeenUseCase,
    TrackActivityUseCase,
    IncomingPushDataRefreshStreamUseCase,
  ],
)
void main() {
  test('brief entry preview is being tracked correctly', () async {
    final trackActivityUseCase = MockTrackActivityUseCase();
    final getCurrentBriefUseCase = MockGetCurrentBriefUseCase();
    final incomingPushDataRefreshStreamUseCase = MockIncomingPushDataRefreshStreamUseCase();
    final isTutorialStepSeenUseCase = MockIsTutorialStepSeenUseCase();
    final dailyBriefPageCubit = DailyBriefPageCubit(
      getCurrentBriefUseCase,
      isTutorialStepSeenUseCase,
      MockSetTutorialStepSeenUseCase(),
      trackActivityUseCase,
      incomingPushDataRefreshStreamUseCase,
    );
    final event = AnalyticsEvent.dailyBriefEntryPreviewed(
      TestData.currentBrief.id,
      TestData.currentBrief.entries.first.id,
      0,
      TestData.currentBrief.entries.first.type.name,
    );

    final entry = TestData.currentBrief.entries.first;

    when(trackActivityUseCase.trackEvent(event)).thenAnswer((_) {});

    when(getCurrentBriefUseCase.call()).thenAnswer((_) async => TestData.currentBrief);

    when(getCurrentBriefUseCase.stream).thenAnswer((_) async* {
      yield TestData.currentBrief;
    });

    when(isTutorialStepSeenUseCase.call(any)).thenAnswer((_) async => true);

    when(incomingPushDataRefreshStreamUseCase.call()).thenAnswer((_) async* {});

    await dailyBriefPageCubit.initialize();

    dailyBriefPageCubit.trackBriefEntryPreviewed(entry, 0, 1);

    await Future.delayed(const Duration(seconds: 2));

    verify(trackActivityUseCase.trackEvent(event)).called(1);
  });

  testWidgets(
    'can navigate from daily brief to article',
    (tester) async {
      await tester.startApp();

      final articleCoverFinder = find.descendant(
        of: find.byType(DailyBriefPage),
        matching: find.byType(ArticleCover),
      );

      await tester.dragUntilVisible(articleCoverFinder, find.byType(DailyBriefPage), const Offset(0, -50));
      await tester.pumpAndSettle();

      await tester.tap(articleCoverFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(MediaItemPage), findsOneWidget);
    },
  );

  testWidgets(
    'can navigate from daily brief to topic',
    (tester) async {
      await tester.startApp();

      final topicCoverFinder = find.descendant(
        of: find.byType(DailyBriefPage),
        matching: find.byType(TopicCover),
      );

      await tester.ensureVisible(topicCoverFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(topicCoverFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(TopicPage), findsOneWidget);
    },
  );

  testWidgets(
    'can navigate from daily brief to explore',
    (tester) async {
      await tester.startApp();
      expect(find.byType(ExplorePage), findsNothing);

      final goToExploreLabelFinder = find.descendant(
        of: find.byType(RelaxView),
        matching: find.byText(LocaleKeys.dailyBrief_goToExplore.tr()),
      );

      await tester.fling(find.byType(TopicCover).first, const Offset(0, -10000), 100);

      await tester.pumpAndSettle();
      expect(goToExploreLabelFinder, findsOneWidget);
      tapTextSpan(goToExploreLabelFinder, LocaleKeys.dailyBrief_goToExplore.tr());
      await tester.pumpAndSettle();

      expect(find.byType(ExplorePage), findsOneWidget);
    },
  );
}
