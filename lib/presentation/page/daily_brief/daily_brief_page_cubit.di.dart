import 'dart:async';
import 'dart:collection';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_wrapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_past_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_should_update_brief_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/mark_entry_as_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/brief_not_initialized_exception.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_paid_subscriptions_use_case.di.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_badge_count_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/is_onboarding_paywall_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/set_onboarding_paywall_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_coach_mark_steps_extension.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_coach_mark_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_refresh_daily_brief_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/connection_state_aware_cubit_mixin.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/tutorial/tutorial_tooltip.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const _minVisibilityToTrack = 0.9;
const _trackEventTotalBufferTime = Duration(seconds: 1);
const _trackEventBufferTime = Duration(milliseconds: 100);
final _requiredEventsCount = _trackEventTotalBufferTime.inMilliseconds / _trackEventBufferTime.inMilliseconds;
final firstTopicKey = GlobalKey();

@injectable
class DailyBriefPageCubit extends Cubit<DailyBriefPageState>
    with ConnectionStateAwareCubitMixin<DailyBriefPageState, void> {
  DailyBriefPageCubit(
    this._getCurrentBriefUseCase,
    this._getPastDaysBriefUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._trackActivityUseCase,
    this._incomingPushDataRefreshStreamUseCase,
    this._getShouldUpdateBriefStreamUseCase,
    this._shouldUsePaidSubscriptionsUseCase,
    this._isOnboardingPaywallSeenUseCase,
    this._hasActiveSubscriptionUseCase,
    this._setOnboardingPaywallSeenUseCase,
    this._markEntryAsSeenUseCase,
    this._shouldRefreshDailyBriefUseCase,
    this._incomingPushBadgeCountStreamUseCase,
    this._isInternetConnectionAvailableUseCase,
  ) : super(DailyBriefPageState.loading());

  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final GetPastBriefUseCase _getPastDaysBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final IncomingPushDataRefreshStreamUseCase _incomingPushDataRefreshStreamUseCase;
  final GetShouldUpdateBriefStreamUseCase _getShouldUpdateBriefStreamUseCase;
  final ShouldUsePaidSubscriptionsUseCase _shouldUsePaidSubscriptionsUseCase;
  final IsOnboardingPaywallSeenUseCase _isOnboardingPaywallSeenUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;
  final SetOnboardingPaywallSeenUseCase _setOnboardingPaywallSeenUseCase;
  final MarkEntryAsSeenUseCase _markEntryAsSeenUseCase;
  final ShouldRefreshDailyBriefUseCase _shouldRefreshDailyBriefUseCase;
  final IncomingPushBadgeCountStreamUseCase _incomingPushBadgeCountStreamUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  final StreamController<_ItemVisibilityEvent> _trackItemController = StreamController();

  late BriefsWrapper _briefsWrapper;
  Brief? _selectedBrief;

  StreamSubscription? _dataRefreshSubscription;
  StreamSubscription? _badgeCountRefreshSubscription;
  StreamSubscription? _currentBriefSubscription;
  StreamSubscription? _shouldUpdateBriefSubscription;
  StreamSubscription? _itemPreviewTrackerSubscription;

  List<TargetFocus> targets = <TargetFocus>[];

  bool _shouldShowTutorialCoachMark = true;

  bool _shouldShowAppBarTitle = false;
  bool _shouldShowCalendar = false;

  @override
  IsInternetConnectionAvailableUseCase get isInternetConnectionAvailableUseCase =>
      _isInternetConnectionAvailableUseCase;

  @override
  Future<void> onOffline(void initialData) async {
    if (_selectedBrief == null) {
      await loadBriefs();
    } else {
      await refetchBriefs();
    }
  }

  @override
  Future<void> onOnline(void initialData) async {
    if (_selectedBrief == null) {
      await loadBriefs();
    } else {
      await refetchBriefs();
    }
  }

  @override
  Future<void> close() async {
    await _dataRefreshSubscription?.cancel();
    await _currentBriefSubscription?.cancel();
    await _shouldUpdateBriefSubscription?.cancel();
    await _trackItemController.close();
    await _itemPreviewTrackerSubscription?.cancel();
    await _badgeCountRefreshSubscription?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    await initializeConnection(null);

    _currentBriefSubscription ??= _getCurrentBriefUseCase.stream.listen((currentBriefWrapper) {
      _briefsWrapper = currentBriefWrapper;
      _updateIdleState(preCacheImages: true);
    });

    _dataRefreshSubscription ??= _incomingPushDataRefreshStreamUseCase().listen((event) {
      Fimber.d('Incoming push - refreshing daily brief');
      _emitEvent(DailyBriefPageState.hasBeenUpdated());
    });

    _badgeCountRefreshSubscription ??= _incomingPushBadgeCountStreamUseCase().listen((event) {
      Fimber.d('Incoming push - badge count');
      _emitEvent(DailyBriefPageState.hasBeenUpdated());
    });

    _shouldUpdateBriefSubscription ??= _getShouldUpdateBriefStreamUseCase().listen((_) => refetchBriefs());

    _itemPreviewTrackerSubscription ??= _itemPreviewTrackerStream.listen((item) {
      _markEntryAsSeen(item.entry);
      _trackActivityUseCase.trackEvent(item.event);
    });

    if (await _shouldUsePaidSubscriptionsUseCase()) {
      if (!(await _hasActiveSubscriptionUseCase()) && !(await _isOnboardingPaywallSeenUseCase())) {
        await _setOnboardingPaywallSeenUseCase();
        _emitEvent(DailyBriefPageState.showPaywall());
      }
    }
  }

  Future<void> shouldRefreshBrief() async {
    final shouldRefreshBrief = await _shouldRefreshDailyBriefUseCase();
    if (shouldRefreshBrief) {
      _emitEvent(DailyBriefPageState.hasBeenUpdated());
    }
  }

  Future<void> initializeTutorialSnackBar() async {
    final isDailyBriefTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.dailyBrief);
    if (!isDailyBriefTutorialStepSeen) {
      _emitEvent(DailyBriefPageState.showTutorialToast());
      await _setTutorialStepSeenUseCase(TutorialStep.dailyBrief);
    }
  }

  Future<void> refetchBriefs() async {
    try {
      _briefsWrapper = await _getCurrentBriefUseCase();
      _selectedBrief ??= _briefsWrapper.currentBrief;

      final todaysBriefSelected = _selectedBrief == _briefsWrapper.currentBrief;

      if (todaysBriefSelected) {
        _selectedBrief = _briefsWrapper.currentBrief;
      } else {
        _selectedBrief = await _getPastDaysBriefUseCase(_selectedBrief!.date);
      }

      _updateIdleState();
    } on NoInternetConnectionException {
      emit(DailyBriefPageState.offline());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadBriefs() async {
    emit(DailyBriefPageState.loading());

    try {
      _briefsWrapper = await _getCurrentBriefUseCase();
      _selectedBrief = _briefsWrapper.currentBrief;
      _updateIdleState(preCacheImages: true);
    } on NoInternetConnectionException {
      emit(DailyBriefPageState.offline());
    } catch (e, s) {
      Fimber.e('Loading briefs failed', ex: e, stacktrace: s);
      emit(DailyBriefPageState.error());
    }
  }

  void toggleCalendar(bool showCalendar) {
    if (showCalendar != _shouldShowCalendar) {
      _shouldShowCalendar = showCalendar;
      _shouldShowCalendar
          ? _trackActivityUseCase.trackEvent(AnalyticsEvent.briefCalendarOpened(_briefsWrapper.currentBrief.id))
          : _trackActivityUseCase.trackEvent(AnalyticsEvent.briefCalendarClosed(_briefsWrapper.currentBrief.id));
      _refreshCurrentState();
    }
  }

  void toggleAppBarTitle(bool showTitle) {
    if (showTitle != _shouldShowAppBarTitle) {
      _shouldShowAppBarTitle = showTitle;
      _refreshCurrentState();
    }
  }

  Future<void> selectBrief(DateTime briefDate) async {
    _shouldShowCalendar = false;
    _refreshCurrentState();

    final localSelectedBrief = _selectedBrief ?? _briefsWrapper.currentBrief;

    if (briefDate.isSameDateAs(localSelectedBrief.date)) return;

    if (briefDate.isSameDateAs(_briefsWrapper.currentBrief.date)) {
      _selectedBrief = _briefsWrapper.currentBrief;
    } else {
      final selectedDay = _briefsWrapper.pastDays.days.firstWhere((element) => element.date.isSameDateAs(briefDate));

      emit(
        DailyBriefPageState.loadingPastDay(
          selectedPastDay: selectedDay,
          pastDays: _briefsWrapper.pastDays,
          showAppBarTitle: _shouldShowAppBarTitle,
          showCalendar: _shouldShowCalendar,
        ),
      );

      _selectedBrief = await _getPastDaysBriefUseCase(briefDate);
    }

    _trackActivityUseCase.trackEvent(
      AnalyticsEvent.calendarBriefSelected(
        _selectedBrief!.id,
        isTodaysBrief: _selectedBrief == _briefsWrapper.currentBrief,
      ),
    );

    _updateIdleState(preCacheImages: true);
  }

  void trackRelaxPage() {
    if (_selectedBrief != null) {
      _trackActivityUseCase.trackEvent(
        AnalyticsEvent.dailyBriefRelaxMessageViewed(_selectedBrief!.id),
      );
      return;
    }

    throw BriefNotInitializedException();
  }

  void trackBriefEntryPreviewed(BriefEntry briefEntry, int position, double visibility) {
    if (_selectedBrief != null) {
      final event = AnalyticsEvent.dailyBriefEntryPreviewed(
        _selectedBrief!.id,
        briefEntry.id,
        position,
        briefEntry.type.name,
      );
      _emitItemPreviewedEvent(briefEntry, event, visibility);
      return;
    }

    throw BriefNotInitializedException();
  }

  void _refreshCurrentState() {
    final DailyBriefPageState? newState = state.maybeMap(
      idle: (state) => state.copyWith(
        showCalendar: _shouldShowCalendar,
        showAppBarTitle: _shouldShowAppBarTitle,
      ),
      loadingPastDay: (state) => state.copyWith(
        showAppBarTitle: _shouldShowAppBarTitle,
        showCalendar: _shouldShowCalendar,
      ),
      loading: (state) => state,
      error: (state) => state,
      offline: (state) => state,
      orElse: () => DailyBriefPageState.idle(
        selectedBrief: _selectedBrief!,
        pastDays: _briefsWrapper.pastDays,
        showCalendar: _shouldShowCalendar,
        showAppBarTitle: _shouldShowAppBarTitle,
      ),
    );

    if (newState != null) {
      emit(newState);
    }
  }

  void _updateIdleState({bool preCacheImages = false}) {
    if (_selectedBrief != null) {
      if (preCacheImages) {
        emit(
          DailyBriefPageState.preCacheImages(
            briefEntryList: _selectedBrief!.allEntries,
          ),
        );
      }

      emit(
        DailyBriefPageState.idle(
          selectedBrief: _selectedBrief!,
          pastDays: _briefsWrapper.pastDays,
          showCalendar: _shouldShowCalendar,
          showAppBarTitle: _shouldShowAppBarTitle,
        ),
      );

      return;
    }

    throw BriefNotInitializedException();
  }

  void _emitItemPreviewedEvent(BriefEntry entry, AnalyticsEvent event, double visibility) {
    final visibilityEvent = _ItemVisibilityEvent(entry, visibility > _minVisibilityToTrack, event);
    if (!isClosed) _trackItemController.add(visibilityEvent);
  }

  Stream<_ItemVisibilityEvent> get _itemPreviewTrackerStream => _trackItemController.stream
      .groupBy(
        (event) => event.entry.id,
        durationSelector: (grouped) => grouped.debounceTime(_trackEventTotalBufferTime * 2),
      )
      .flatMap(
        (stream) => stream
            .bufferTime(_trackEventBufferTime)
            .scan<Queue<List<_ItemVisibilityEvent>>>(
              (accumulated, buffered, index) {
                accumulated.add(buffered);
                if (accumulated.length > _requiredEventsCount) {
                  accumulated.removeFirst();
                }

                return accumulated;
              },
              Queue(),
            )
            .where((queue) => queue.length == _requiredEventsCount)
            .where((queue) => queue.expand((events) => events).every((event) => event.visible))
            .where((queue) => queue.isNotEmpty)
            .where((queue) => queue.expand((events) => events).isNotEmpty)
            .map((queue) => queue.expand((events) => events).first)
            .distinct(),
      )
      .distinct();

  Future<void> _markEntryAsSeen(BriefEntry entry) async {
    if (entry.isNew) {
      await _markEntryAsSeenUseCase(entry);
    }
  }

  Future<void> initializeTutorialCoachMark() async {
    final isTopicCardTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.dailyBriefTopicCard);

    if (!isTopicCardTutorialStepSeen && _shouldShowTutorialCoachMark) {
      targets.clear();
      _emitEvent(DailyBriefPageState.shouldShowTopicCardTutorialCoachMark());
      _initializeTopicCardTutorialCoachMarkTarget();
      _shouldShowTutorialCoachMark = false;
    }
  }

  TutorialCoachMark tutorialCoachMark() => TutorialCoachMark(
        targets: targets,
        paddingFocus: 0,
        opacityShadow: 0.5,
        hideSkip: true,
        onSkip: onSkipTutorialCoachMark,
      );

  void _initializeTopicCardTutorialCoachMarkTarget() {
    targets.add(
      TargetFocus(
        identify: DailyBriefPageTutorialCoachMarkStep.topicCard.key,
        keyTarget: firstTopicKey,
        color: AppColors.overlay,
        enableTargetTab: false,
        pulseVariation: Tween(begin: 1.0, end: 1.0),
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              left: AppDimens.m,
              right: AppDimens.m,
              bottom: AppDimens.xl,
            ),
            builder: (context, controller) {
              return TutorialTooltip(
                text: context.l10n.tutorial_topicCoachmarkText,
                dismissButtonText: context.l10n.common_gotIt,
                onDismiss: () => _emitEvent(DailyBriefPageState.finishTutorialCoachMark()),
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: AppDimens.m,
        paddingFocus: 0,
      ),
    );
  }

  Future<void> showTopicCardTutorialCoachMark() async {
    bool isTopicCardTutorialStepSeen = await _isTutorialStepSeenUseCase.call(TutorialStep.dailyBriefTopicCard);
    if (!isTopicCardTutorialStepSeen) {
      _emitEvent(DailyBriefPageState.showTopicCardTutorialCoachMark());
      await _setTutorialStepSeenUseCase.call(TutorialStep.dailyBriefTopicCard);
      isTopicCardTutorialStepSeen = true;
    }
  }

  void onSkipTutorialCoachMark() {
    targets.removeAt(0);
  }

  Future<bool> onAndroidBackButtonPress(bool isShowingTutorialCoachMark) async {
    if (isShowingTutorialCoachMark) {
      _emitEvent(DailyBriefPageState.skipTutorialCoachMark(jumpToNextCoachMark: false));
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  void _emitEvent(DailyBriefPageState event) {
    final currentState = state;
    emit(event);
    emit(currentState);
  }
}

class _ItemVisibilityEvent {
  _ItemVisibilityEvent(this.entry, this.visible, this.event);

  final BriefEntry entry;
  final bool visible;
  final AnalyticsEvent event;
}
