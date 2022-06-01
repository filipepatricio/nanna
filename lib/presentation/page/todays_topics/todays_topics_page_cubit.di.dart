import 'dart:async';
import 'dart:collection';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

const _minVisibilityToTrack = 0.9;
const _trackEventTotalBufferTime = Duration(seconds: 1);
const _trackEventBufferTime = Duration(milliseconds: 100);
final _requiredEventsCount = _trackEventTotalBufferTime.inMilliseconds / _trackEventBufferTime.inMilliseconds;

@injectable
class TodaysTopicsPageCubit extends Cubit<TodaysTopicsPageState> {
  TodaysTopicsPageCubit(
    this._getCurrentBriefUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._trackActivityUseCase,
    this._incomingPushDataRefreshStreamUseCase,
  ) : super(TodaysTopicsPageState.loading());

  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final IncomingPushDataRefreshStreamUseCase _incomingPushDataRefreshStreamUseCase;

  final StreamController<_ItemVisibilityEvent> _trackItemController = StreamController();

  late bool _isTodaysTopicsTutorialStepSeen;
  late CurrentBrief _currentBrief;

  StreamSubscription? _dataRefreshSubscription;
  StreamSubscription? _currentBriefSubscription;

  @override
  Future<void> close() async {
    await _dataRefreshSubscription?.cancel();
    await _currentBriefSubscription?.cancel();
    await _trackItemController.close();
    await super.close();
  }

  Future<void> initialize() async {
    await loadTodaysTopics();

    _currentBriefSubscription = _getCurrentBriefUseCase.stream.listen((newCurrentBrief) {
      _currentBrief = newCurrentBrief;
      emit(TodaysTopicsPageState.idle(_currentBrief));
    });

    _dataRefreshSubscription = _incomingPushDataRefreshStreamUseCase().listen((event) {
      Fimber.d('Incoming push - refreshing todays topics');
      loadTodaysTopics();
    });

    _isTodaysTopicsTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.todaysTopics);
    if (!_isTodaysTopicsTutorialStepSeen) {
      emit(TodaysTopicsPageState.showTutorialToast(LocaleKeys.tutorial_todaysTopicsSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.todaysTopics);
    }

    _initializeItemPreviewTracker();
  }

  Future<void> loadTodaysTopics() async {
    emit(TodaysTopicsPageState.loading());

    try {
      _currentBrief = await _getCurrentBriefUseCase();
      emit(TodaysTopicsPageState.idle(_currentBrief));
    } catch (e, s) {
      Fimber.e('Loading current brief failed', ex: e, stacktrace: s);
      emit(TodaysTopicsPageState.error());
    }
  }

  void trackRelaxPage() =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.dailyBriefRelaxMessageViewed(_currentBrief.id));

  void trackTopicPreviewed(String topicId, int position, double visibility) {
    final event = AnalyticsEvent.dailyBriefTopicPreviewed(_currentBrief.id, topicId, position);
    _emitItemPreviewedEvent(topicId, event, visibility);
  }

  void _emitItemPreviewedEvent(String id, AnalyticsEvent event, double visibility) {
    final visibilityEvent = _ItemVisibilityEvent(id, visibility > _minVisibilityToTrack, event);
    _trackItemController.add(visibilityEvent);
  }

  void _initializeItemPreviewTracker() {
    _trackItemController.stream
        .groupBy(
          (value) => value.id,
          durationSelector: (grouped) => grouped.debounceTime(_trackEventTotalBufferTime * 2),
        )
        .flatMap(
          (value) => value
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
              .where((event) => event.length == _requiredEventsCount)
              .where((event) => event.expand((item) => item).every((item) => item.visible))
              .where((event) => event.isNotEmpty)
              .map((event) => event.expand((element) => element).first.event)
              .distinct(),
        )
        .distinct()
        .listen((event) => _trackActivityUseCase.trackEvent(event));
  }
}

class _ItemVisibilityEvent {
  _ItemVisibilityEvent(this.id, this.visible, this.event);

  final String id;
  final bool visible;
  final AnalyticsEvent event;
}
