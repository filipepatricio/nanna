import 'dart:async';

import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/show_pills_on_explore_page_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExplorePageCubit extends Cubit<ExplorePageState> {
  ExplorePageCubit(
    this._getExploreContentUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._showPillsOnExplorePageUseCase,
  ) : super(ExplorePageState.initialLoading());

  final GetExploreContentUseCase _getExploreContentUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final ShowPillsOnExplorePageUseCase _showPillsOnExplorePageUseCase;

  late bool _isExploreTutorialStepSeen;
  late ExplorePageState _latestIdleState;

  StreamSubscription? _exploreContentSubscription;

  @override
  Future<void> close() async {
    await _exploreContentSubscription?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    emit(ExplorePageState.initialLoading());

    final showPills = await _showPillsOnExplorePageUseCase();
    _exploreContentSubscription = showPills
        ? _getExploreContentUseCase.highlightedContentStream.listen(_processAndEmitExploreContent)
        : _getExploreContentUseCase.contentStream.listen(_processAndEmitExploreContent);

    try {
      await _showTutorialSnackBar();
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
      emit(ExplorePageState.error());
    }
  }

  Future<void> loadExplorePageData() async {
    try {
      await _fetchExploreContent();
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
      emit(ExplorePageState.error());
    }
  }

  Future<void> _fetchExploreContent() async {
    final showPills = await _showPillsOnExplorePageUseCase();
    final exploreContent = await _getExploreContentUseCase(showPills: showPills);
    _processAndEmitExploreContent(exploreContent);
  }

  void _processAndEmitExploreContent(ExploreContent exploreContent) {
    final pills = exploreContent.pills;
    _latestIdleState = ExplorePageState.idle(
      [
        if (pills != null) ExploreItem.pills(pills),
        ...exploreContent.areas.map(ExploreItem.stream).toList(),
      ],
    );

    emit(_latestIdleState);
  }

  Future<void> _showTutorialSnackBar() async {
    _isExploreTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.explore);
    if (!_isExploreTutorialStepSeen) {
      emit(ExplorePageState.showTutorialToast(LocaleKeys.tutorial_exploreSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.explore);
    }
  }

  Future<void> search() async {
    emit(ExplorePageState.search());
  }

  Future<void> idle() async {
    emit(_latestIdleState);
  }
}
