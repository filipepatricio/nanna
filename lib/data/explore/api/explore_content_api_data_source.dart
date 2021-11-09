import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_section_dto.dart';

abstract class ExploreContentApiDataSource {
  Future<ExploreContentDTO> getExploreContent();

  Future<ExploreContentSectionDTO> getPaginatedExploreSection(String id, int limit, int offset);
}
