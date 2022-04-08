import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_topics_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/next_topics_page_loader.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const _paginationLimit = 10;

@injectable
class TopicsSeeAllPageCubit extends Cubit<TopicsSeeAllPageState> {
  final GetExplorePaginatedTopicsUseCase _getExplorePaginatedTopicsUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  late NextTopicPageLoader _nextArticlePageLoader;
  late PaginationEngine<Topic> _paginationEngine;
  late String _areaId;

  List<Topic> _topics = [];
  bool _allLoaded = false;

  TopicsSeeAllPageCubit(
    this._getExplorePaginatedTopicsUseCase,
    this._trackActivityUseCase,
  ) : super(TopicsSeeAllPageState.loading());

  Future<void> initialize(String areaId, List<Topic> topics) async {
    _areaId = areaId;
    _topics = topics;
    _nextArticlePageLoader = NextTopicPageLoader(_getExplorePaginatedTopicsUseCase, areaId);
    _paginationEngine = PaginationEngine(_nextArticlePageLoader);
    _paginationEngine.initialize(topics);

    _trackActivityUseCase.trackEvent(AnalyticsEvent.exploreAreaScrolled(_areaId, 0));

    emit(TopicsSeeAllPageState.withPagination(topics));
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
