import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_page_state.dart';
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
  //TODO: add user first sign in logic
  final bool _isUserFirstSignIn = true;
  bool _isSummaryCardTutorialCoachMarkFinished = false;
  bool _isMediaItemTutorialCoachMarkFinished = false;

  bool get isSummaryCardTutorialCoachMarkFinished => _isSummaryCardTutorialCoachMarkFinished;
  bool get isMediaItemTutorialCoachMarkFinished => _isMediaItemTutorialCoachMarkFinished;

  List<TargetFocus> targets = <TargetFocus>[];
  final summaryCardKey = GlobalKey();
  final mediaItemKey = GlobalKey();

  TopicPageCubit() : super(TopicPageState.loading());

  Future<void> initialize() async {
    emit(TopicPageState.idle());
    initializeTutorialCoachMarkTargets();
    if (_isUserFirstSignIn) {
      emit(
          TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicTitle.tr(), LocaleKeys.tutorial_topicMessage.tr()));
    }
  }

  void initializeTutorialCoachMarkTargets() {
    targets.clear();
    targets.add(TargetFocus(
      identify: 'summaryCardKey',
      keyTarget: summaryCardKey,
      color: AppColors.shadowColor,
      enableOverlayTab: true,
      pulseVariation: Tween(begin: 1.0, end: 1.0),
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition: CustomTargetContentPosition(top: AppDimens.m),
          builder: (context, controller) {
            return TutorialTooltip(
                text: LocaleKeys.tutorial_topicTooltipText.tr(),
                dismissButtonText: LocaleKeys.common_continue.tr(),
                onDismiss: () => emit(TopicPageState.skipTutorialCoachMark()));
          },
        )
      ],
      shape: ShapeLightFocus.RRect,
      radius: 5,
    ));
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
            customPosition: CustomTargetContentPosition(top: AppDimens.m),
            builder: (context, controller) {
              return TutorialTooltip(
                  text: LocaleKeys.tutorial_mediaItemTooltipText.tr(),
                  dismissButtonText: LocaleKeys.common_done.tr(),
                  onDismiss: () => emit(TopicPageState.finishTutorialCoachMark()));
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
  }

  void showSummaryCardTutorialCoachMark() {
    if (!_isSummaryCardTutorialCoachMarkFinished) {
      emit(TopicPageState.showSummaryCardTutorialCoachMark());
      _isSummaryCardTutorialCoachMarkFinished = true;
    }
  }

  void showMediaItemTutorialCoachMark() {
    if (!_isMediaItemTutorialCoachMarkFinished) {
      emit(TopicPageState.showMediaItemTutorialCoachMark());
      _isMediaItemTutorialCoachMarkFinished = true;
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
