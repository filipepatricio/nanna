import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_data.dart';
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
  late MockTrackActivityUseCase trackActivityUseCase;
  late MockGetCurrentBriefUseCase getCurrentBriefUseCase;
  late MockIncomingPushDataRefreshStreamUseCase incomingPushDataRefreshStreamUseCase;
  late MockIsTutorialStepSeenUseCase isTutorialStepSeenUseCase;
  late DailyBriefPageCubit dailyBriefPageCubit;

  setUp(() {
    trackActivityUseCase = MockTrackActivityUseCase();
    getCurrentBriefUseCase = MockGetCurrentBriefUseCase();
    incomingPushDataRefreshStreamUseCase = MockIncomingPushDataRefreshStreamUseCase();
    isTutorialStepSeenUseCase = MockIsTutorialStepSeenUseCase();
    dailyBriefPageCubit = DailyBriefPageCubit(
      getCurrentBriefUseCase,
      isTutorialStepSeenUseCase,
      MockSetTutorialStepSeenUseCase(),
      trackActivityUseCase,
      incomingPushDataRefreshStreamUseCase,
    );
  });

  test('brief entry preview is being tracked correctly', () async {
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
}
