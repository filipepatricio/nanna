import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_highlighted_content_dto.dt.dart';

abstract class ExploreContentApiDataSource {
  Future<ExploreHighlightedContentDTO> getExploreHighlightedContent();

  Future<ExploreContentAreaDTO> getPaginatedExploreArea(String id, int limit, int offset);

  Stream<ExploreHighlightedContentDTO?> exploreHighlightedContentStream();
}
