import 'dart:async';
import 'dart:collection';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

const _minVisibilityToTrack = 0.9;
const _trackEventTotalBufferTime = Duration(seconds: 1);
const _trackEventBufferTime = Duration(milliseconds: 100);
final _requiredEventsCount = _trackEventTotalBufferTime.inMilliseconds / _trackEventBufferTime.inMilliseconds;

@injectable
class DailyBriefPageCubit extends Cubit<DailyBriefPageState> {
  DailyBriefPageCubit(
    this._getCurrentBriefUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._trackActivityUseCase,
    this._incomingPushDataRefreshStreamUseCase,
  ) : super(DailyBriefPageState.loading());

  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final IncomingPushDataRefreshStreamUseCase _incomingPushDataRefreshStreamUseCase;

  final StreamController<_ItemVisibilityEvent> _trackItemController = StreamController();

  late bool _isDailyBriefTutorialStepSeen;
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
    await loadDailyBrief();

    _currentBriefSubscription = _getCurrentBriefUseCase.stream.listen((newCurrentBrief) {
      _currentBrief = newCurrentBrief;
      emit(DailyBriefPageState.idle(_currentBrief));
    });

    _dataRefreshSubscription = _incomingPushDataRefreshStreamUseCase().listen((event) {
      Fimber.d('Incoming push - refreshing daily brief');
      loadDailyBrief();
    });

    _isDailyBriefTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.dailyBrief);
    if (!_isDailyBriefTutorialStepSeen) {
      emit(DailyBriefPageState.showTutorialToast(LocaleKeys.tutorial_dailyBriefSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.dailyBrief);
    }

    _initializeItemPreviewTracker();
  }

  Future<void> loadDailyBrief() async {
    emit(DailyBriefPageState.loading());

    try {
      _currentBrief = await _getCurrentBriefUseCase();
      emit(DailyBriefPageState.idle(_currentBrief));
    } catch (e, s) {
      Fimber.e('Loading current brief failed', ex: e, stacktrace: s);
      emit(DailyBriefPageState.error());
    }
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
}

class _ItemVisibilityEvent {
  _ItemVisibilityEvent(this.id, this.visible, this.event);

  final String id;
  final bool visible;
  final AnalyticsEvent event;
}
