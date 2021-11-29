import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class TodaysTopicsPageCubit extends Cubit<TodaysTopicsPageState> {
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  late CurrentBrief _currentBrief;

  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  late bool _isTodaysTopicsTutorialStepSeen;

  TodaysTopicsPageCubit(this._getCurrentBriefUseCase, this._isTutorialStepSeenUseCase, this._setTutorialStepSeenUseCase,
      this._trackActivityUseCase)
      : super(TodaysTopicsPageState.loading());

  Future<void> initialize() async {
    emit(TodaysTopicsPageState.loading());

    try {
      _currentBrief = await _getCurrentBriefUseCase();
      emit(TodaysTopicsPageState.idle(_currentBrief));

      _isTodaysTopicsTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.todaysTopics);
      if (!_isTodaysTopicsTutorialStepSeen) {
        emit(TodaysTopicsPageState.showTutorialToast(LocaleKeys.tutorial_todaysTopicsSnackBarText.tr()));
        await _setTutorialStepSeenUseCase.call(TutorialStep.todaysTopics);
      }
    } catch (e, s) {
      Fimber.e('Loading current brief failed', ex: e, stacktrace: s);
      emit(TodaysTopicsPageState.error());
    }
  }

  void trackRelaxPage() =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.dailyBriefRelaxMessageViewed(_currentBrief.id));

  void trackTopicPageSwipe(String topicId, int position) =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.dailyBriefTopicPreviewed(_currentBrief.id, topicId, position));
}
