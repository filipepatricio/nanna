import 'dart:async';

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

@injectable
class TodaysTopicsPageCubit extends Cubit<TodaysTopicsPageState> {
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final IncomingPushDataRefreshStreamUseCase _incomingPushDataRefreshStreamUseCase;

  late bool _isTodaysTopicsTutorialStepSeen;
  late CurrentBrief _currentBrief;

  StreamSubscription? _dataRefreshSubscription;

  TodaysTopicsPageCubit(
    this._getCurrentBriefUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._trackActivityUseCase,
    this._incomingPushDataRefreshStreamUseCase,
  ) : super(TodaysTopicsPageState.loading());

  @override
  Future<void> close() async {
    await _dataRefreshSubscription?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    await loadTodaysTopics();

    _dataRefreshSubscription = _incomingPushDataRefreshStreamUseCase().listen((event) {
      Fimber.d('Incoming push - refreshing todays topics');
      loadTodaysTopics();
    });

    _isTodaysTopicsTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.todaysTopics);
    if (!_isTodaysTopicsTutorialStepSeen) {
      emit(TodaysTopicsPageState.showTutorialToast(LocaleKeys.tutorial_todaysTopicsSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.todaysTopics);
    }
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

  void trackTopicPreviewed(String topicId, int position) =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.dailyBriefTopicPreviewed(_currentBrief.id, topicId, position));
}
