import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/mark_topic_as_visited_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_coach_mark_steps_extension.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_coach_mark_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/tutorial/tutorial_tooltip.dart';
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
  ) : super(TopicPageState.loading());

  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final MarkTopicAsVisitedUseCase _markTopicAsVisitedUseCase;

  late Topic _topic;
  late String? _briefId;

  String? get briefId => _briefId;

  List<TargetFocus> targets = <TargetFocus>[];
  final mediaItemKey = GlobalKey();

  Future<void> initializeWithSlug(String slug, String? briefId) async {
    emit(TopicPageState.loading());

    try {
      final topic = await _getTopicBySlugUseCase(slug, true);
      initialize(topic, briefId);
    } catch (e, s) {
      Fimber.e('Topic loading failed', ex: e, stacktrace: s);
      emit(TopicPageState.error());
    }
  }

  void initialize(Topic topic, String? briefId) {
    _topic = topic;
    _briefId = briefId;
    if (!topic.visited) {
      try {
        _markTopicAsVisitedUseCase(topic.slug);
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
      emit(TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicSnackBarText.tr()));
      await _setTutorialStepSeenUseCase.call(TutorialStep.topic);
    }
  }

  Future<void> initializeTutorialCoachMark() async {
    final isTopicMediaItemTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topicMediaItem);

    targets.clear();
    if (!isTopicMediaItemTutorialStepSeen) {
      emit(TopicPageState.shouldShowMediaItemTutorialCoachMark());
      _initializeMediaTypeTutorialCoachMarkTarget();
    }
  }

  TutorialCoachMark tutorialCoachMark(BuildContext context) => TutorialCoachMark(
        targets: targets,
        paddingFocus: 0,
        opacityShadow: 0.5,
        hideSkip: true,
        onSkip: onSkipTutorialCoachMark,
      );

  void _initializeMediaTypeTutorialCoachMarkTarget() {
    targets.add(
      TargetFocus(
        identify: TopicPageTutorialCoachMarkStep.mediaItem.key,
        keyTarget: mediaItemKey,
        color: AppColors.shadowColor,
        enableTargetTab: false,
        pulseVariation: Tween(begin: 1.0, end: 1.0),
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(bottom: AppDimens.xl),
            builder: (context, controller) {
              return TutorialTooltip(
                text: LocaleKeys.tutorial_mediaItemTooltipText.tr(),
                dismissButtonText: LocaleKeys.common_gotIt.tr(),
                onDismiss: () => emit(TopicPageState.finishTutorialCoachMark()),
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: AppDimens.m,
      ),
    );
  }

  Future<void> showMediaItemTutorialCoachMark() async {
    bool isTopicMediaItemTutorialStepSeen = await _isTutorialStepSeenUseCase.call(TutorialStep.topicMediaItem);
    if (!isTopicMediaItemTutorialStepSeen) {
      emit(TopicPageState.showMediaItemTutorialCoachMark());
      await _setTutorialStepSeenUseCase.call(TutorialStep.topicMediaItem);
      isTopicMediaItemTutorialStepSeen = true;
    }
  }

  void onSkipTutorialCoachMark() {
    targets.removeAt(0);
  }

  Future<bool> onAndroidBackButtonPress(bool isShowingTutorialCoachMark) async {
    if (isShowingTutorialCoachMark) {
      emit(TopicPageState.skipTutorialCoachMark(jumpToNextCoachMark: true));
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}
