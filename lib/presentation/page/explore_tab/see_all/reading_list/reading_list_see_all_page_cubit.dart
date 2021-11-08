import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_topics_use_case.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/reading_list/next_topics_page_loader.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/reading_list/reading_list_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';

const _paginationLimit = 10;

class ReadingListSeeAllPageCubit extends Cubit<ReadingListSeeAllPageState> {
  final GetExplorePaginatedTopicsUseCase _getExplorePaginatedTopicsUseCase;
  late NextTopicPageLoader _nextArticlePageLoader;
  late PaginationEngine<Topic> _paginationEngine;

  List<Topic> _topics = [];
  bool _allLoaded = false;

  ReadingListSeeAllPageCubit(
      this._getExplorePaginatedTopicsUseCase,
      ) : super(ReadingListSeeAllPageState.loading());

  Future<void> initialize(String sectionId, List<Topic> topics) async {
    _topics = topics;
    _nextArticlePageLoader = NextTopicPageLoader(_getExplorePaginatedTopicsUseCase, sectionId);
    _paginationEngine = PaginationEngine(_nextArticlePageLoader);
    _paginationEngine.initialize(topics);

    emit(ReadingListSeeAllPageState.withPagination(topics));
  }

  Future<void> loadNextPage() async {
    if (_isInLoadingState() || _allLoaded) return;

    emit(ReadingListSeeAllPageState.loadingMore(_topics));
    final limit = _topics.length.isEven ? _paginationLimit : _paginationLimit - 1;
    final result = await _paginationEngine.loadMore(limitOverride: limit);

    _topics = result.data;
    _allLoaded = result.allLoaded;

    if (_allLoaded) {
      emit(ReadingListSeeAllPageState.allLoaded(_topics));
    } else {
      emit(ReadingListSeeAllPageState.withPagination(_topics));
    }
  }

  bool _isInLoadingState() => state.maybeMap(
    loadingMore: (_) => true,
    orElse: () => false,
  );
}
