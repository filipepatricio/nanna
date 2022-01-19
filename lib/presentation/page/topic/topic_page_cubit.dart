import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_coach_mark_steps_extension.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_coach_mark_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/tutorial/tutorial_tooltip.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

@injectable
class TopicPageCubit extends Cubit<TopicPageState> {
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;

  late bool _isTopicTutorialStepSeen;
  late bool _isTopicSummaryCardTutorialStepSeen;
  late bool _isTopicMediaItemTutorialStepSeen;

  List<TargetFocus> targets = <TargetFocus>[];
  final summaryCardKey = GlobalKey();
  final mediaItemKey = GlobalKey();

  TopicPageCubit(
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._getTopicBySlugUseCase,
  ) : super(TopicPageState.loading());

  Future<void> initializeWithSlug(String slug) async {
    try {
      final topic = await _getTopicBySlugUseCase(slug);
      await initialize(topic);
    } catch (e, s) {
      Fimber.e('Topic loading failed', ex: e, stacktrace: s);
    }
  }

  Future<void> initialize(Topic topic) async {
    emit(TopicPageState.idle(topic));

    _isTopicTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topic);
    _isTopicSummaryCardTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topicSummaryCard);
    _isTopicMediaItemTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topicMediaItem);

    if (!_isTopicTutorialStepSeen) {
      emit(TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicSnackBarText.tr()));
      await _setTutorialStepSeenUseCase.call(TutorialStep.topic);
    }
    targets.clear();
    if (!_isTopicSummaryCardTutorialStepSeen) {
      emit(TopicPageState.shouldShowSummaryCardTutorialCoachMark());
      _initializeSummaryCardTutorialCoachMarkTarget();
    }
    if (!_isTopicMediaItemTutorialStepSeen) {
      emit(TopicPageState.shouldShowMediaItemTutorialCoachMark());
      _initializeMediaTypeTutorialCoachMarkTarget();
    }
  }

  TutorialCoachMark tutorialCoachMark(BuildContext context) {
    return TutorialCoachMark(
      context,
      targets: targets,
      paddingFocus: 0,
      opacityShadow: 0.5,
      hideSkip: true,
      onSkip: onSkipTutorialCoachMark,
      onClickTarget: onClickTargetTutorialCoachMark,
      onClickOverlay: onClickOverlayTutorialCoachMark,
    );
  }

  void _initializeSummaryCardTutorialCoachMarkTarget() {
    targets.add(TargetFocus(
      identify: TutorialCoachMarkStep.summaryCard.key,
      keyTarget: summaryCardKey,
      color: AppColors.shadowColor,
      enableOverlayTab: true,
      pulseVariation: Tween(begin: 1.0, end: 1.0),
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition: CustomTargetContentPosition(bottom: 50),
          builder: (context, controller) {
            return TutorialTooltip(
                text: LocaleKeys.tutorial_topicTooltipText.tr(),
                tutorialIndex: TutorialCoachMarkStep.values.indexOf(TutorialCoachMarkStep.summaryCard),
                tutorialLength: TutorialCoachMarkStep.values.length,
                dismissButtonText: LocaleKeys.common_continue.tr(),
                tutorialTooltipPosition: TutorialTooltipPosition.bottom,
                onDismiss: () => emit(TopicPageState.skipTutorialCoachMark()));
          },
        )
      ],
      shape: ShapeLightFocus.RRect,
      radius: 0,
    ));
  }

  void _initializeMediaTypeTutorialCoachMarkTarget() {
    targets.add(
      TargetFocus(
        identify: TutorialCoachMarkStep.mediaItem.key,
        keyTarget: mediaItemKey,
        color: AppColors.shadowColor,
        enableOverlayTab: true,
        pulseVariation: Tween(begin: 1.0, end: 1.0),
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(top: 140),
            builder: (context, controller) {
              return TutorialTooltip(
                  text: LocaleKeys.tutorial_mediaItemTooltipText.tr(),
                  tutorialIndex: TutorialCoachMarkStep.values.indexOf(TutorialCoachMarkStep.mediaItem),
                  tutorialLength: TutorialCoachMarkStep.values.length,
                  dismissButtonText: LocaleKeys.common_done.tr(),
                  tutorialTooltipPosition: TutorialTooltipPosition.top,
                  onDismiss: () => emit(TopicPageState.finishTutorialCoachMark()));
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 0,
      ),
    );
  }

  Future<void> showSummaryCardTutorialCoachMark() async {
    _isTopicSummaryCardTutorialStepSeen = await _isTutorialStepSeenUseCase.call(TutorialStep.topicSummaryCard);
    if (!_isTopicSummaryCardTutorialStepSeen) {
      emit(TopicPageState.showSummaryCardTutorialCoachMark());
      await _setTutorialStepSeenUseCase.call(TutorialStep.topicSummaryCard);
      _isTopicSummaryCardTutorialStepSeen = true;
    }
  }

  Future<void> showMediaItemTutorialCoachMark() async {
    _isTopicMediaItemTutorialStepSeen = await _isTutorialStepSeenUseCase.call(TutorialStep.topicMediaItem);
    if (!_isTopicMediaItemTutorialStepSeen) {
      emit(TopicPageState.showMediaItemTutorialCoachMark());
      await _setTutorialStepSeenUseCase.call(TutorialStep.topicMediaItem);
      _isTopicMediaItemTutorialStepSeen = true;
    }
  }

  void onSkipTutorialCoachMark() {
    targets.removeAt(0);
  }

  void onClickTargetTutorialCoachMark(TargetFocus targetFocus) {
    emit(TopicPageState.skipTutorialCoachMark());
  }

  void onClickOverlayTutorialCoachMark(TargetFocus targetFocus) {
    emit(TopicPageState.skipTutorialCoachMark());
  }

  Future<bool> onAndroidBackButtonPress(bool isShowingTutorialCoachMark) async {
    if (isShowingTutorialCoachMark) {
      emit(TopicPageState.skipTutorialCoachMark());
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}
