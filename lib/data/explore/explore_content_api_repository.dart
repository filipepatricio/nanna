import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_section_dto_mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExploreContentRepository)
class ExploreContentApiRepository implements ExploreContentRepository {
  final ExploreContentApiDataSource _dataSource;
  final ExploreContentDTOMapper _exploreContentDTOMapper;
  final ExploreContentSectionDTOMapper _exploreContentSectionDTOMapper;

  ExploreContentApiRepository(
    this._dataSource,
    this._exploreContentDTOMapper,
    this._exploreContentSectionDTOMapper,
  );

  @override
  Future<ExploreContent> getExploreContent() async {
    final dto = await _dataSource.getExploreContent();
    return _exploreContentDTOMapper(dto);
  }

  @override
  Future<List<MediaItemArticle>> getPaginatedArticles(String sectionId, int limit, int offset) async {
    final dto = await _dataSource.getPaginatedExploreSection(sectionId, limit, offset);
    final section = _exploreContentSectionDTOMapper(dto);

    return section.maybeMap(
      articles: (data) => data.articles,
      articleWithFeature: (data) => [data.featuredArticle] + data.articles,
      orElse: () => [],
    );
  }

  @override
  Future<List<Topic>> getPaginatedTopics(String sectionId, int limit, int offset) async {
    final dto = await _dataSource.getPaginatedExploreSection(sectionId, limit, offset);
    final section = _exploreContentSectionDTOMapper(dto);

    return section.maybeMap(
      topics: (data) => data.topics,
      orElse: () => [],
    );
  }
}
