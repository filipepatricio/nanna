import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/add_interests/add_interests_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/widgets/daily_brief_calendar.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_success_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  late DailyBriefPageCubit dailyBriefPageCubit;
  late MockTrackActivityUseCase trackActivityUseCase;
  late MockGetCurrentBriefUseCase getCurrentBriefUseCase;
  late MockGetPastBriefUseCase getPastBriefUseCase;
  late MockIncomingPushDataRefreshStreamUseCase incomingPushDataRefreshStreamUseCase;
  late MockBackgroundIncomingPushDataRefreshStreamUseCase backgroundIncomingPushDataRefreshStreamUseCase;
  late MockIsTutorialStepSeenUseCase isTutorialStepSeenUseCase;
  late MockSetTutorialStepSeenUseCase setTutorialStepSeenUseCase;
  late MockGetShouldUpdateBriefStreamUseCase getShouldUpdateBriefStreamUseCase;
  late MockMarkEntryAsSeenUseCase mockMarkEntryAsSeenUseCase;
  late MockShouldRefreshDailyBriefUseCase shouldRefreshDailyBriefUseCase;
  late MockIncomingPushBriefEntriesUpdatedStreamUseCase incomingPushBriefEntriesUpdatedStreamUseCase;
  late MockIsInternetConnectionAvailableUseCase isInternetConnectionAvailableUseCase;
  late MockShouldUseObservableQueriesUseCase shouldUseObservableQueriesUseCase;
  late MockSetNeedsRefreshDailyBriefUseCase setNeedsRefreshDailyBriefUseCase;
  late MockIsAddInterestsPageSeenUseCase isAddInterestsPageSeenUseCase;
  late MockSetAddInterestsPageSeenUseCase setAddInterestsPageSeenUseCase;
  late MockGetCategoryPreferencesUseCase getCategoryPreferencesUseCase;
  late MockRequestTrackingPermissionUseCase requestTrackingPermissionUseCase;
  late MockGetActiveSubscriptionUseCase getActiveSubscriptionUseCase;

  final entry = TestData.currentBrief.allEntries.first;
  final event = AnalyticsEvent.dailyBriefEntryPreviewed(
    TestData.currentBrief.id,
    entry.id,
    0,
    entry.type.name,
  );

  setUp(() {
    trackActivityUseCase = MockTrackActivityUseCase();
    getCurrentBriefUseCase = MockGetCurrentBriefUseCase();
    getPastBriefUseCase = MockGetPastBriefUseCase();
    incomingPushDataRefreshStreamUseCase = MockIncomingPushDataRefreshStreamUseCase();
    backgroundIncomingPushDataRefreshStreamUseCase = MockBackgroundIncomingPushDataRefreshStreamUseCase();
    isTutorialStepSeenUseCase = MockIsTutorialStepSeenUseCase();
    setTutorialStepSeenUseCase = MockSetTutorialStepSeenUseCase();
    getShouldUpdateBriefStreamUseCase = MockGetShouldUpdateBriefStreamUseCase();
    mockMarkEntryAsSeenUseCase = MockMarkEntryAsSeenUseCase();
    shouldRefreshDailyBriefUseCase = MockShouldRefreshDailyBriefUseCase();
    incomingPushBriefEntriesUpdatedStreamUseCase = MockIncomingPushBriefEntriesUpdatedStreamUseCase();
    isInternetConnectionAvailableUseCase = MockIsInternetConnectionAvailableUseCase();
    shouldUseObservableQueriesUseCase = MockShouldUseObservableQueriesUseCase();
    setNeedsRefreshDailyBriefUseCase = MockSetNeedsRefreshDailyBriefUseCase();
    isAddInterestsPageSeenUseCase = MockIsAddInterestsPageSeenUseCase();
    setAddInterestsPageSeenUseCase = MockSetAddInterestsPageSeenUseCase();
    getCategoryPreferencesUseCase = MockGetCategoryPreferencesUseCase();
    requestTrackingPermissionUseCase = MockRequestTrackingPermissionUseCase();
    getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();

    dailyBriefPageCubit = DailyBriefPageCubit(
      getCurrentBriefUseCase,
      getPastBriefUseCase,
      isTutorialStepSeenUseCase,
      setTutorialStepSeenUseCase,
      trackActivityUseCase,
      incomingPushDataRefreshStreamUseCase,
      backgroundIncomingPushDataRefreshStreamUseCase,
      getShouldUpdateBriefStreamUseCase,
      mockMarkEntryAsSeenUseCase,
      shouldRefreshDailyBriefUseCase,
      incomingPushBriefEntriesUpdatedStreamUseCase,
      isInternetConnectionAvailableUseCase,
      shouldUseObservableQueriesUseCase,
      setNeedsRefreshDailyBriefUseCase,
      getCategoryPreferencesUseCase,
      isAddInterestsPageSeenUseCase,
      setAddInterestsPageSeenUseCase,
      requestTrackingPermissionUseCase,
    );

    when(trackActivityUseCase.trackEvent(event)).thenAnswer((_) {});
    when(getCurrentBriefUseCase.call()).thenAnswer((_) async => TestData.briefWrapper);
    when(getPastBriefUseCase.call(TestData.pastDaysBriefs.days.first.date)).thenAnswer((_) async => TestData.pastBrief);
    when(getCurrentBriefUseCase.stream).thenAnswer((_) async* {
      yield TestData.briefWrapper;
    });
    when(getShouldUpdateBriefStreamUseCase.call()).thenAnswer((_) async* {});
    when(isTutorialStepSeenUseCase.call(any)).thenAnswer((_) async => true);
    when(incomingPushDataRefreshStreamUseCase.call()).thenAnswer((_) async* {});
    when(backgroundIncomingPushDataRefreshStreamUseCase.call()).thenAnswer((_) async* {});
    when(getCategoryPreferencesUseCase.call()).thenAnswer((_) async => TestData.categoryPreferences);
    when(shouldRefreshDailyBriefUseCase.call()).thenAnswer((_) async => false);
    when(incomingPushBriefEntriesUpdatedStreamUseCase.call()).thenAnswer((_) async* {});
    when(isInternetConnectionAvailableUseCase.call()).thenAnswer((_) async => true);
    when(isInternetConnectionAvailableUseCase.stream).thenAnswer((_) async* {});
    when(shouldUseObservableQueriesUseCase.call()).thenAnswer((_) async => true);
    when(setNeedsRefreshDailyBriefUseCase.call(any)).thenAnswer((_) async => false);
  });

  test('brief entry preview is being tracked correctly', () async {
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
        matching: find.bySubtype<ArticleCover>(),
      );

      await tester.dragUntilVisible(articleCoverFinder.first, find.byType(DailyBriefPage), const Offset(0, -50));
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
        matching: find.bySubtype<TopicCover>(),
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
        matching: find.byText(MockDTO.callToAction.actionText),
      );

      await tester.fling(find.byType(DailyBriefPage), const Offset(0, -20000), 100);

      await tester.pumpAndSettle();
      expect(goToExploreLabelFinder, findsOneWidget);
      await tester.tap(goToExploreLabelFinder);
      await tester.pumpAndSettle();

      expect(find.byType(ExplorePage), findsOneWidget);
    },
  );

  testWidgets(
    'can open and close calendar',
    (tester) async {
      await tester.startApp();

      expect(find.byType(DailyBriefCalendar), findsNothing);

      await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
      await tester.pumpAndSettle();

      expect(find.byType(DailyBriefCalendar), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
      await tester.pumpAndSettle();

      expect(find.byType(DailyBriefCalendar), findsNothing);
    },
  );

  testWidgets(
    'can change date in calendar',
    (tester) async {
      await withClock(
        Clock(() => DateTime(2022, 07, 14)),
        () async {
          await tester.startApp();

          await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
          await tester.pumpAndSettle();

          final appBarTitle = find.descendant(
            of: find.byType(FlexibleSpaceBar),
            matching: find.byText("Yesterday"),
          );

          final calendarItem = find.descendant(
            of: find.byType(DailyBriefCalendar),
            matching: find.byText("13"),
          );

          expect(appBarTitle, findsNothing);

          await tester.tap(calendarItem);
          await tester.pumpAndSettle();

          expect(appBarTitle, findsOneWidget);
        },
      );
    },
  );

  testWidgets(
    'changing date in calendar closes calendar',
    (tester) async {
      await withClock(
        Clock(() => DateTime(2022, 07, 14)),
        () async {
          await tester.startApp();

          await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
          await tester.pumpAndSettle();

          final calendarItem = find.descendant(
            of: find.byType(DailyBriefCalendar),
            matching: find.byText("13"),
          );

          await tester.tap(calendarItem);
          await tester.pumpAndSettle();

          expect(calendarItem, findsNothing);
        },
      );
    },
  );

  testWidgets(
    "can't change date in calendar if brief is null",
    (tester) async {
      await withClock(
        Clock(() => DateTime(2022, 07, 14)),
        () async {
          await tester.startApp();

          await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
          await tester.pumpAndSettle();

          final appBarTitle = find.descendant(
            of: find.byType(FlexibleSpaceBar),
            matching: find.byText("Yesterday"),
          );

          final calendarItem = find.descendant(
            of: find.byType(DailyBriefCalendar),
            matching: find.byText("13"),
          );

          final calendarItemNull = find.descendant(
            of: find.byType(DailyBriefCalendar),
            matching: find.byText("11"),
          );

          await tester.tap(calendarItem);
          await tester.pumpAndSettle();

          expect(appBarTitle, findsOneWidget);

          await tester.tapAt(tester.getCenter(find.byType(AnimatedRotation).first));
          await tester.pumpAndSettle();

          await tester.tap(calendarItemNull);
          await tester.pumpAndSettle();

          expect(appBarTitle, findsOneWidget);
        },
      );
    },
  );

  testWidgets(
    'add interests page is shown when user has not set them',
    (tester) async {
      when(isAddInterestsPageSeenUseCase.call()).thenAnswer((_) async => false);
      when(getCategoryPreferencesUseCase.call()).thenAnswer((_) async => []);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(() => dailyBriefPageCubit);
        },
      );

      verify(getCategoryPreferencesUseCase.call()).called(1);
      verify(isAddInterestsPageSeenUseCase.call()).called(1);
      verify(setAddInterestsPageSeenUseCase.call()).called(1);
      expect(find.byType(AddInterestsPage), findsOneWidget);
    },
  );

  testWidgets(
    'add interests page is not shown when user has already set them',
    (tester) async {
      when(isAddInterestsPageSeenUseCase.call()).thenAnswer((_) async => false);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(() => dailyBriefPageCubit);
        },
      );

      verify(getCategoryPreferencesUseCase.call()).called(1);
      verifyNever(isAddInterestsPageSeenUseCase.call());
      verify(setAddInterestsPageSeenUseCase.call()).called(1);
      expect(find.byType(AddInterestsPage), findsNothing);
    },
  );
  testWidgets(
    'add interests page is not shown when user has already seen it',
    (tester) async {
      when(isAddInterestsPageSeenUseCase.call()).thenAnswer((_) async => true);
      when(getCategoryPreferencesUseCase.call()).thenAnswer((_) async => []);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(() => dailyBriefPageCubit);
        },
      );

      verify(getCategoryPreferencesUseCase.call()).called(1);
      verify(isAddInterestsPageSeenUseCase.call()).called(1);
      verifyNever(setAddInterestsPageSeenUseCase.call());
      expect(find.byType(AddInterestsPage), findsNothing);
    },
  );

  testWidgets(
    'subscription success page is shown after add interests page if user is on trial',
    (tester) async {
      when(isAddInterestsPageSeenUseCase.call()).thenAnswer((_) async => false);
      when(getCategoryPreferencesUseCase.call()).thenAnswer((_) async => []);
      when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
      when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(() => dailyBriefPageCubit);
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        },
      );

      verify(getCategoryPreferencesUseCase.call()).called(1);
      verify(isAddInterestsPageSeenUseCase.call()).called(1);
      verify(setAddInterestsPageSeenUseCase.call()).called(1);
      expect(find.byType(AddInterestsPage), findsOneWidget);

      for (var i = 0; i < 4; i++) {
        await tester.ensureVisible(find.byType(InterestListItem).at(i));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(InterestListItem).at(i));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byText(l10n.common_continue));
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionSuccessPage), findsOneWidget);
    },
  );

  testWidgets(
    'current brief stream is not called if feature flag is off',
    (tester) async {
      when(shouldUseObservableQueriesUseCase.call()).thenAnswer((_) async => false);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DailyBriefPageCubit>(() => dailyBriefPageCubit);
        },
      );

      verifyNever(getCurrentBriefUseCase.stream);
    },
  );
}
