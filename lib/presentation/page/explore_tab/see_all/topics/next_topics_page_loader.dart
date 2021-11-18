import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_topics_use_case.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';

class NextTopicPageLoader implements NextPageLoader<Topic> {
  final GetExplorePaginatedTopicsUseCase _getExplorePaginatedTopicsUseCase;
  final String areaId;

  NextTopicPageLoader(
    this._getExplorePaginatedTopicsUseCase,
    this.areaId,
  );

  @override
  Future<List<Topic>> call(NextPageConfig config) {
    return _getExplorePaginatedTopicsUseCase(areaId, config.limit, config.offset);
  }
}
