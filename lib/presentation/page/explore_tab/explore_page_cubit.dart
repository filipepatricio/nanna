import 'package:better_informed_mobile/domain/explore/use_case/get_explore_content_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExplorePageCubit extends Cubit<ExplorePageState> {
  final GetExploreContentUseCase _getExploreContentUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  late bool _isExploreTutorialStepSeen;

  ExplorePageCubit(
    this._getExploreContentUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
  ) : super(ExplorePageState.initialLoading());

  Future<void> initialize() async {
    emit(ExplorePageState.initialLoading());

    try {
      await _loadExplorePageData();
      await _showTutorialSnackBar();
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
      emit(ExplorePageState.error());
    }
  }

  Future<void> loadExplorePageData() async {
    try {
      await _loadExplorePageData();
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
      emit(ExplorePageState.error());
    }
  }

  Future<void> _loadExplorePageData() async {
    final exploreContent = await _getExploreContentUseCase();
    emit(ExplorePageState.idle(exploreContent.areas));
  }

  Future<void> _showTutorialSnackBar() async {
    _isExploreTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.explore);
    if (!_isExploreTutorialStepSeen) {
      emit(ExplorePageState.showTutorialToast(LocaleKeys.tutorial_exploreSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.explore);
    }
  }
}
