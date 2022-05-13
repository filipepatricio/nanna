import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_highlighted_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_area_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_highlighted_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: ExploreContentRepository)
class ExploreContentApiRepository implements ExploreContentRepository {
  ExploreContentApiRepository(
    this._exploreContentApiDataSource,
    this._exploreContentDTOMapper,
    this._exploreContentAreaDTOMapper,
    this._exploreHighlightedContentDTOMapper,
  );

  final ExploreContentApiDataSource _exploreContentApiDataSource;
  final ExploreContentDTOMapper _exploreContentDTOMapper;
  final ExploreHighlightedContentDTOMapper _exploreHighlightedContentDTOMapper;
  final ExploreContentAreaDTOMapper _exploreContentAreaDTOMapper;

  @override
  Future<ExploreContent> getExploreContent() async {
    final dto = await _exploreContentApiDataSource.getExploreContent();
    return _exploreContentDTOMapper(dto);
  }

  @override
  Future<ExploreContent> getExploreHighlightedContent() async {
    final dto = await _exploreContentApiDataSource.getExploreHighlightedContent();
    return _exploreHighlightedContentDTOMapper(dto);
  }

  @override
  Future<List<MediaItemArticle>> getPaginatedArticles(String areaId, int limit, int offset) async {
    final dto = await _exploreContentApiDataSource.getPaginatedExploreArea(areaId, limit, offset);
    final area = _exploreContentAreaDTOMapper(dto);

    return area.maybeMap(
      articles: (data) => data.articles,
      orElse: () => [],
    );
  }

  @override
  Future<List<TopicPreview>> getPaginatedTopics(String areaId, int limit, int offset) async {
    final dto = await _exploreContentApiDataSource.getPaginatedExploreArea(areaId, limit, offset);
    final area = _exploreContentAreaDTOMapper(dto);

    return area.maybeMap(
      topics: (data) => data.topics,
      smallTopics: (data) => data.topics,
      highlightedTopics: (data) => data.topics,
      orElse: () => [],
    );
  }

  @override
  Stream<ExploreContent> exploreContentStream() => _exploreContentApiDataSource
      .exploreContentStream()
      .whereType<ExploreContentDTO>()
      .map((dto) => _exploreContentDTOMapper(dto));

  @override
  Stream<ExploreContent> exploreHighlightedContentStream() => _exploreContentApiDataSource
      .exploreHighlightedContentStream()
      .whereType<ExploreHighlightedContentDTO>()
      .map((dto) => _exploreHighlightedContentDTOMapper(dto));
}
