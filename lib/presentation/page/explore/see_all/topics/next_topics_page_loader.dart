import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_topics_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';

class NextTopicPageLoader implements NextPageLoader<TopicPreview> {
  NextTopicPageLoader(
    this._getExplorePaginatedTopicsUseCase,
    this.areaId,
  );
  final GetExplorePaginatedTopicsUseCase _getExplorePaginatedTopicsUseCase;
  final String areaId;

  @override
  Future<List<TopicPreview>> call(NextPageConfig config) {
    return _getExplorePaginatedTopicsUseCase(areaId, config.limit, config.offset);
  }
}
