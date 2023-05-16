import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/mark_topic_as_visited_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

@injectable
class TopicPageCubit extends Cubit<TopicPageState> {
  TopicPageCubit(
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._getTopicBySlugUseCase,
    this._trackActivityUseCase,
    this._markTopicAsVisitedUseCase,
    this._isGuestModeUseCase,
  ) : super(TopicPageState.loading());

  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final MarkTopicAsVisitedUseCase _markTopicAsVisitedUseCase;
  final IsGuestModeUseCase _isGuestModeUseCase;

  late Topic _topic;
  late String? _briefId;

  String? get briefId => _briefId;

  List<TargetFocus> targets = <TargetFocus>[];
  final mediaItemKey = GlobalKey();

  Future<void> initializeWithSlug(String slug, String? briefId) async {
    emit(TopicPageState.loading());

    try {
      final topic = await _getTopicBySlugUseCase(slug, true);
      await initialize(topic, briefId);
    } catch (e, s) {
      Fimber.e('Topic loading failed', ex: e, stacktrace: s);
      emit(TopicPageState.error());
    }
  }

  Future<void> initialize(Topic topic, String? briefId) async {
    _topic = topic;
    _briefId = briefId;
    final isGuestMode = await _isGuestModeUseCase();
    if (!topic.visited && !isGuestMode) {
      try {
        await _markTopicAsVisitedUseCase(topic.slug);
      } catch (e, s) {
        Fimber.e('Marking topic as visited failed', ex: e, stacktrace: s);
      }
    }

    _trackActivityUseCase.trackPage(AnalyticsPage.topic(_topic.id, _briefId));

    emit(TopicPageState.idle(_topic));
  }

  Future<void> initializeTutorialStep() async {
    final isTopicTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topic);
    if (!isTopicTutorialStepSeen) {
      emit(TopicPageState.showTutorialToast());
      await _setTutorialStepSeenUseCase.call(TutorialStep.topic);
    }
  }
}
