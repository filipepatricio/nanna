import 'package:better_informed_mobile/domain/tutorial/data/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/reset_tutorial_flow_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/tutorial/tutorial_tooltip.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

@injectable
class TopicPageCubit extends Cubit<TopicPageState> {
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final ResetTutorialFlowUseCase _resetTutorialFlowUseCase;

  late bool _isTopicTutorialStepSeen;
  late bool _isTopicSummaryCardTutorialStepSeen;
  late bool _isTopicMediaItemTutorialStepSeen;

  bool get isTopicSummaryCardTutorialStepSeen => _isTopicSummaryCardTutorialStepSeen;
  bool get isTopicMediaItemTutorialStepSeen => _isTopicMediaItemTutorialStepSeen;

  List<TargetFocus> targets = <TargetFocus>[];
  final summaryCardKey = GlobalKey();
  final mediaItemKey = GlobalKey();

  TopicPageCubit(this._isTutorialStepSeenUseCase, this._setTutorialStepSeenUseCase, this._resetTutorialFlowUseCase)
      : super(TopicPageState.loading());

  Future<void> initialize() async {
    emit(TopicPageState.idle());

    await _resetTutorialFlowUseCase();

    _isTopicTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topic);
    _isTopicSummaryCardTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topicSummaryCard);
    _isTopicMediaItemTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topicMediaItem);

    if (!_isTopicTutorialStepSeen) {
      emit(TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicSnackBarText.tr()));
      await _setTutorialStepSeenUseCase.call(TutorialStep.topic);
    }
    targets.clear();
    if (!_isTopicSummaryCardTutorialStepSeen) {
      initializeSummaryCardTutorialCoachMarkTarget();
    }
    if (!_isTopicMediaItemTutorialStepSeen) {
      initializeMediaTypeTutorialCoachMarkTarget();
    }
  }

  void initializeSummaryCardTutorialCoachMarkTarget() {
    targets.add(TargetFocus(
      identify: 'summaryCardKey',
      keyTarget: summaryCardKey,
      color: AppColors.shadowColor,
      enableOverlayTab: true,
      pulseVariation: Tween(begin: 1.0, end: 1.0),
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition: CustomTargetContentPosition(bottom: 0),
          builder: (context, controller) {
            return TutorialTooltip(
                text: LocaleKeys.tutorial_topicTooltipText.tr(),
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

  void initializeMediaTypeTutorialCoachMarkTarget() {
    targets.add(
      TargetFocus(
        identify: 'mediaItemKey',
        keyTarget: mediaItemKey,
        color: AppColors.shadowColor,
        enableOverlayTab: true,
        pulseVariation: Tween(begin: 1.0, end: 1.0),
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(top: AppDimens.s),
            builder: (context, controller) {
              return TutorialTooltip(
                  text: LocaleKeys.tutorial_mediaItemTooltipText.tr(),
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

  void onFinishTutorialCoachMark() {
    print('onFinishTutorialCoachMark');
  }

  void onSkipTutorialCoachMark() {
    print('onSkipTutorialCoachMark');
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
