import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicPageCubit extends Cubit<TopicPageState> {
  //TODO: add user first sign in logic
  final bool _isUserFirstSignIn = true;

  TopicPageCubit() : super(TopicPageState.loading());

  Future<void> initialize() async {
    emit(TopicPageState.idle());

    if (_isUserFirstSignIn) {
      emit(
          TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicTitle.tr(), LocaleKeys.tutorial_topicMessage.tr()));
    }
  }

  void showTutorialCoachMark() {
    emit(TopicPageState.showTutorialCoachMark());
  }
}
