import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

@injectable
class TopicPageCubit extends Cubit<TopicPageState> {
  //TODO: add user first sign in logic
  final bool _isUserFirstSignIn = true;
  late TutorialCoachMark tutorialCoachMark;
  bool _isSummaryCardTutorialCoachMarkFinished = false;
  bool _isMediaItemTutorialCoachMarkFinished = false;

  bool get isSummaryCardTutorialCoachMarkFinished => _isSummaryCardTutorialCoachMarkFinished;
  bool get isMediaItemTutorialCoachMarkFinished => _isMediaItemTutorialCoachMarkFinished;

  TopicPageCubit() : super(TopicPageState.loading());

  Future<void> initialize() async {
    emit(TopicPageState.idle());

    if (_isUserFirstSignIn) {
      emit(
          TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicTitle.tr(), LocaleKeys.tutorial_topicMessage.tr()));
    }
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

  Future<bool> onAndroidBackButtonPress() async {
    if (tutorialCoachMark.isShowing) {
      tutorialCoachMark.skip();
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}
