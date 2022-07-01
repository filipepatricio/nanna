import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_articles_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';

class NextArticlePageLoader implements NextPageLoader<MediaItemArticle> {
  NextArticlePageLoader(this._getExplorePaginatedArticlesUseCase, this.sectionId);
  final GetExplorePaginatedArticlesUseCase _getExplorePaginatedArticlesUseCase;
  final String sectionId;

  @override
  Future<List<MediaItemArticle>> call(NextPageConfig config) {
    return _getExplorePaginatedArticlesUseCase(sectionId, config.limit, config.offset);
  }
}
