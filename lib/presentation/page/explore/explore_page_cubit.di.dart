import 'dart:async';

import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_should_update_explore_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_observable_queries_use_case.di.dart';
import 'package:better_informed_mobile/domain/search/use_case/get_search_history_use_case.di.dart';
import 'package:better_informed_mobile/domain/search/use_case/remove_search_history_query_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
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
    this._shouldUseObservableQueriesUseCase,
    this._isSignedInUseCase,
  ) : super(const ExplorePageState.initialLoading());

  final GetExploreContentUseCase _getExploreContentUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final GetShouldUpdateExploreStreamUseCase _getShouldUpdateExploreStreamUseCase;
  final ShouldUseObservableQueriesUseCase _shouldUseObservableQueriesUseCase;
  final GetSearchHistoryUseCase _getSearchHistoryUseCase;
  final RemoveSearchHistoryQueryUseCase _removeSearchHistoryQueryUseCase;
  final IsSignedInUseCase _isSignedInUseCase;

  late bool _isSignedIn;
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
    emit(const ExplorePageState.initialLoading());

    _isSignedIn = await _isSignedInUseCase();

    await _exploreContentSubscription?.cancel();
    await _shouldUpdateExploreSubscription?.cancel();

    if (await _shouldUseObservableQueriesUseCase() && _isSignedIn) {
      _exploreContentSubscription = _getExploreContentUseCase.exploreContentStream.listen((content) async {
        final idleState = await _processAndEmitExploreContent(content);
        state.maybeMap(
          search: (_) => {},
          searchHistory: (_) => {},
          orElse: () => emit(idleState),
        );
      });
    }

    _shouldUpdateExploreSubscription = _getShouldUpdateExploreStreamUseCase().listen((_) {
      state.mapOrNull(
        idle: (_) => loadExplorePageData(),
        error: (_) => loadExplorePageData(),
      );
    });

    await _showTutorialSnackBar();
    await loadExplorePageData();
  }

  Future<void> loadExplorePageData() async {
    try {
      await _fetchExploreContent();
    } on NoInternetConnectionException {
      emit(const ExplorePageState.offline());
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
      emit(const ExplorePageState.error());
    }
  }

  Future<void> _fetchExploreContent() async {
    final exploreContent = _isSignedIn ? await _getExploreContentUseCase() : await _getExploreContentUseCase.guest();
    final idleState = await _processAndEmitExploreContent(exploreContent);
    emit(idleState);
  }

  Future<ExplorePageState> _processAndEmitExploreContent(ExploreContent exploreContent) async {
    final categories = await _getFeaturedCategoriesUseCase();
    final content = [
      ExploreItem.pills(
        categories.map((category) => category.asCategoryWithItems()).toList(),
      ),
      ...exploreContent.areas.map(ExploreItem.stream).toList(),
    ];

    _latestIdleState = _isSignedIn ? ExplorePageState.idle(content) : ExplorePageState.idleGuest(content);
    return _latestIdleState;
  }

  Future<void> _showTutorialSnackBar() async {
    _isExploreTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.explore);
    if (!_isExploreTutorialStepSeen) {
      emit(const ExplorePageState.showTutorialToast());
      await _setTutorialStepSeenUseCase(TutorialStep.explore);
    }
  }

  Future<void> startTyping() async {
    if (!_isSignedIn) {
      return;
    }

    emit(const ExplorePageState.startTyping());
    final searchHistory = await _getSearchHistoryUseCase.call();
    if (searchHistory.isNotEmpty) {
      emit(ExplorePageState.searchHistory(searchHistory));
    }
  }

  Future<void> search() async {
    if (!_isSignedIn) {
      return;
    }

    emit(const ExplorePageState.startSearching());
    emit(const ExplorePageState.search());
  }

  Future<void> explore() async {
    emit(const ExplorePageState.startExploring());
    emit(_latestIdleState);
  }

  Future<void> removeSearchHistoryQuery(String query) async {
    final searchHistory = await _removeSearchHistoryQueryUseCase(query);
    emit(const ExplorePageState.searchHistoryUpdated());
    await _checkSearchHistory(searchHistory);
  }

  Future<void> _checkSearchHistory(List<String> searchHistory) async {
    if (searchHistory.isNotEmpty) {
      emit(ExplorePageState.searchHistory(searchHistory));
    } else {
      emit(const ExplorePageState.startExploring());
      emit(_latestIdleState);
    }
  }

  Future<void> searchHistoryQueryTapped(String query) async {
    emit(ExplorePageState.searchHistoryQueryTapped(query));
  }
}
