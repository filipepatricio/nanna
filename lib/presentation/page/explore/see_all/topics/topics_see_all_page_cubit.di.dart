import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_topics_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/next_topics_page_loader.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const _paginationLimit = 10;

@injectable
class TopicsSeeAllPageCubit extends Cubit<TopicsSeeAllPageState> {
  TopicsSeeAllPageCubit(
    this._getExplorePaginatedTopicsUseCase,
    this._trackActivityUseCase,
  ) : super(TopicsSeeAllPageState.loading());
  final GetExplorePaginatedTopicsUseCase _getExplorePaginatedTopicsUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  late NextTopicPageLoader _nextTopicPageLoader;
  late PaginationEngine<TopicPreview> _paginationEngine;
  late String _areaId;

  List<TopicPreview> _topics = [];
  bool _allLoaded = false;

  Future<void> initialize(String areaId, List<TopicPreview>? topics) async {
    _areaId = areaId;
    _nextTopicPageLoader = NextTopicPageLoader(_getExplorePaginatedTopicsUseCase, areaId);
    _paginationEngine = PaginationEngine(_nextTopicPageLoader);
    if (topics != null) {
      _topics = topics;
      _paginationEngine.initialize(topics);
      emit(TopicsSeeAllPageState.withPagination(topics));
      _trackActivityUseCase.trackEvent(AnalyticsEvent.exploreAreaScrolled(_areaId, 0));
    } else {
      await loadNextPage();
    }
  }

  Future<void> loadNextPage() async {
    if (_isInLoadingState() || _allLoaded) return;

    emit(TopicsSeeAllPageState.loadingMore(_topics));

    _trackActivityUseCase.trackEvent(AnalyticsEvent.exploreAreaScrolled(_areaId, _topics.length));

    final limit = _topics.length.isEven ? _paginationLimit : _paginationLimit - 1;
    final result = await _paginationEngine.loadMore(limitOverride: limit);

    _topics = result.data;
    _allLoaded = result.allLoaded;

    if (_allLoaded) {
      emit(TopicsSeeAllPageState.allLoaded(_topics));
    } else {
      emit(TopicsSeeAllPageState.withPagination(_topics));
    }
  }

  bool _isInLoadingState() => state.maybeMap(
        loadingMore: (_) => true,
        orElse: () => false,
      );
}
