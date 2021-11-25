import 'package:better_informed_mobile/domain/explore/use_case/get_explore_content_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/data/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExplorePageCubit extends Cubit<ExplorePageState> {
  final GetExploreContentUseCase _getExploreContentUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  late bool _isExploreTutorialStepSeen;

  ExplorePageCubit(this._getExploreContentUseCase, this._isTutorialStepSeenUseCase, this._setTutorialStepSeenUseCase)
      : super(ExplorePageState.initialLoading());

  Future<void> initialize() async {
    try {
      final exploreContent = await _getExploreContentUseCase();
      emit(ExplorePageState.idle(exploreContent.areas));

      _isExploreTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.explore);
      if (!_isExploreTutorialStepSeen) {
        emit(ExplorePageState.showTutorialToast(LocaleKeys.tutorial_exploreSnackBarText.tr()));
        await _setTutorialStepSeenUseCase(TutorialStep.explore);
      }
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
    }
  }
}
