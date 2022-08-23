import 'dart:async';
import 'dart:collection';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_past_days_briefs_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_coach_mark_steps_extension.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_coach_mark_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/tutorial/tutorial_tooltip.dart';
import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
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
class DailyBriefPageCubit extends Cubit<DailyBriefPageState> {
  DailyBriefPageCubit(
    this._getCurrentBriefUseCase,
    this._getPastDaysBriesfUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._trackActivityUseCase,
    this._incomingPushDataRefreshStreamUseCase,
  ) : super(DailyBriefPageState.loading());

  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final GetPastDaysBriesfUseCase _getPastDaysBriesfUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final IncomingPushDataRefreshStreamUseCase _incomingPushDataRefreshStreamUseCase;

  final StreamController<_ItemVisibilityEvent> _trackItemController = StreamController();

  late Brief _currentBrief;
  List<PastDaysBrief> _pastDaysBriefs = [];

  StreamSubscription? _dataRefreshSubscription;
  StreamSubscription? _currentBriefSubscription;

  List<TargetFocus> targets = <TargetFocus>[];

  bool _shouldShowTutorialCoachMark = true;

  bool _shouldShowAppBarTitle = false;
  bool _shouldShowCalendar = false;

  @override
  Future<void> close() async {
    await _dataRefreshSubscription?.cancel();
    await _currentBriefSubscription?.cancel();
    await _trackItemController.close();
    await super.close();
  }

  Future<void> initialize() async {
    await loadBriefs();

    _currentBriefSubscription = _getCurrentBriefUseCase.stream.listen((currentBrief) {
      _currentBrief = currentBrief;
      _updateIdleState(preCacheImages: true);
    });

    _dataRefreshSubscription = _incomingPushDataRefreshStreamUseCase().listen((event) {
      Fimber.d('Incoming push - refreshing daily brief');
      loadBriefs();
    });

    _initializeItemPreviewTracker();

    await loadPastDaysBriefs();
  }

  Future<void> initializeTutorialSnackBar() async {
    final isDailyBriefTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.dailyBrief);
    if (!isDailyBriefTutorialStepSeen) {
      emit(DailyBriefPageState.showTutorialToast(LocaleKeys.tutorial_dailyBriefSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.dailyBrief);
    }
  }

  Future<void> loadPastDaysBriefs() async {
    try {
      _pastDaysBriefs = await _getPastDaysBriesfUseCase();
      _updateIdleState();
    } catch (e, s) {
      Fimber.e('Loading past days briefs failed', ex: e, stacktrace: s);
    }
  }

  Future<void> loadBriefs() async {
    emit(DailyBriefPageState.loading());

    try {
      _currentBrief = await _getCurrentBriefUseCase();
      _updateIdleState(preCacheImages: true);
    } catch (e, s) {
      Fimber.e('Loading briefs failed', ex: e, stacktrace: s);
      emit(DailyBriefPageState.error());
    }
  }

  void _updateIdleState({bool preCacheImages = false}) {
    emit(
      DailyBriefPageState.idle(
        currentBrief: _currentBrief,
        pastDaysBriefs: _pastDaysBriefs,
        showCalendar: _shouldShowCalendar,
        showAppBarTitle: _shouldShowAppBarTitle,
      ),
    );

    if (preCacheImages) emit(DailyBriefPageState.preCacheImages(briefEntryList: _currentBrief.allEntries));
  }

  void toggleCalendar(bool showCalendar) {
    if (showCalendar != _shouldShowCalendar) {
      _shouldShowCalendar = showCalendar;
      _updateIdleState();
    }
  }

  void toggleAppBarTitle(bool showTitle) {
    if (showTitle != _shouldShowAppBarTitle) {
      _shouldShowAppBarTitle = showTitle;
      _updateIdleState();
    }
  }

  void selectBrief(Brief? brief) {
    if (brief == null) return;

    _currentBrief = brief;

    if (_currentBrief.date == clock.now() && (_currentBriefSubscription?.isPaused ?? false)) {
      _currentBriefSubscription?.resume();
    } else if (!(_currentBriefSubscription?.isPaused ?? true)) {
      _currentBriefSubscription?.pause();
    }

    _updateIdleState(preCacheImages: true);
  }

  void trackRelaxPage() =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.dailyBriefRelaxMessageViewed(_currentBrief.id));

  void trackBriefEntryPreviewed(BriefEntry briefEntry, int position, double visibility) {
    final event =
        AnalyticsEvent.dailyBriefEntryPreviewed(_currentBrief.id, briefEntry.id, position, briefEntry.type.name);
    _emitItemPreviewedEvent(briefEntry.id, event, visibility);
  }

  void _emitItemPreviewedEvent(String id, AnalyticsEvent event, double visibility) {
    final visibilityEvent = _ItemVisibilityEvent(id, visibility > _minVisibilityToTrack, event);
    if (!isClosed) _trackItemController.add(visibilityEvent);
  }

  void _initializeItemPreviewTracker() {
    _trackItemController.stream
        .groupBy(
          (event) => event.id,
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
              .map((queue) => queue.expand((events) => events).first.event)
              .distinct(),
        )
        .distinct()
        .listen((event) => _trackActivityUseCase.trackEvent(event));
  }

  Future<void> initializeTutorialCoachMark() async {
    final isTopicCardTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.dailyBriefTopicCard);

    if (!isTopicCardTutorialStepSeen && _shouldShowTutorialCoachMark) {
      targets.clear();
      emit(DailyBriefPageState.shouldShowTopicCardTutorialCoachMark());
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
        color: AppColors.shadowColor,
        enableTargetTab: false,
        pulseVariation: Tween(begin: 1.0, end: 1.0),
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(bottom: AppDimens.xl),
            builder: (context, controller) {
              return TutorialTooltip(
                text: LocaleKeys.tutorial_topicTooltipText.tr(),
                dismissButtonText: LocaleKeys.common_gotIt.tr(),
                onDismiss: () => emit(DailyBriefPageState.finishTutorialCoachMark()),
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
      emit(DailyBriefPageState.showTopicCardTutorialCoachMark());
      await _setTutorialStepSeenUseCase.call(TutorialStep.dailyBriefTopicCard);
      isTopicCardTutorialStepSeen = true;
    }
  }

  void onSkipTutorialCoachMark() {
    targets.removeAt(0);
  }

  Future<bool> onAndroidBackButtonPress(bool isShowingTutorialCoachMark) async {
    if (isShowingTutorialCoachMark) {
      emit(DailyBriefPageState.skipTutorialCoachMark(jumpToNextCoachMark: false));
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}

class _ItemVisibilityEvent {
  _ItemVisibilityEvent(this.id, this.visible, this.event);

  final String id;
  final bool visible;
  final AnalyticsEvent event;
}
