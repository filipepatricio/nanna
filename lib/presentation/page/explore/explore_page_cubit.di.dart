import 'dart:async';

import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_should_update_explore_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/search/use_case/get_search_history_use_case.di.dart';
import 'package:better_informed_mobile/domain/search/use_case/remove_search_history_query_use_case.di.dart';
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
    this._getFeaturedCategoriesUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._getSearchHistoryUseCase,
    this._removeSearchHistoryQueryUseCase,
    this._getShouldUpdateExploreStreamUseCase,
  ) : super(ExplorePageState.initialLoading());

  final GetExploreContentUseCase _getExploreContentUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final GetShouldUpdateExploreStreamUseCase _getShouldUpdateExploreStreamUseCase;

  final GetSearchHistoryUseCase _getSearchHistoryUseCase;
  final RemoveSearchHistoryQueryUseCase _removeSearchHistoryQueryUseCase;

  late bool _isExploreTutorialStepSeen;
  late ExplorePageState _latestIdleState;

  StreamSubscription? _exploreContentSubscription;
  StreamSubscription? _shouldUpdateExploreSubscription;

  @override
  Future<void> close() async {
    await _exploreContentSubscription?.cancel();
    await _shouldUpdateExploreSubscription?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    emit(ExplorePageState.initialLoading());

    _exploreContentSubscription =
        _getExploreContentUseCase.highlightedContentStream.listen(_processAndEmitExploreContent);

    _shouldUpdateExploreSubscription = _getShouldUpdateExploreStreamUseCase().listen((_) => loadExplorePageData());

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
    final exploreContent = await _getExploreContentUseCase();
    await _processAndEmitExploreContent(exploreContent);
  }

  Future<void> _processAndEmitExploreContent(ExploreContent exploreContent) async {
    final categories = await _getFeaturedCategoriesUseCase();
    _latestIdleState = ExplorePageState.idle(
      [
        ExploreItem.pills(
          categories.map((category) => category.asCategoryWithItems()).toList(),
        ),
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

  Future<void> startTyping() async {
    emit(ExplorePageState.startTyping());
    final searchHistory = await _getSearchHistoryUseCase.call();
    if (searchHistory.isNotEmpty) {
      emit(ExplorePageState.searchHistory(searchHistory));
    }
  }

  Future<void> search() async {
    emit(ExplorePageState.startSearching());
    emit(ExplorePageState.search());
  }

  Future<void> explore() async {
    emit(ExplorePageState.startExploring());
    emit(_latestIdleState);
  }

  Future<void> removeSearchHistoryQuery(String query) async {
    final searchHistory = await _removeSearchHistoryQueryUseCase(query);
    emit(ExplorePageState.searchHistoryUpdated());
    await _checkSearchHistory(searchHistory);
  }

  Future<void> _checkSearchHistory(List<String> searchHistory) async {
    if (searchHistory.isNotEmpty) {
      emit(ExplorePageState.searchHistory(searchHistory));
    } else {
      emit(ExplorePageState.startExploring());
      emit(_latestIdleState);
    }
  }

  Future<void> searchHistoryQueryTapped(String query) async {
    emit(ExplorePageState.searchHistoryQueryTapped(query));
  }
}
