import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dt.dart';

abstract class ExploreContentApiDataSource {
  Future<ExploreContentDTO> getExploreContent();

  Future<ExploreContentDTO> getExploreContentGuest();

  Future<ExploreContentAreaDTO> getPaginatedExploreArea(String id, int limit, int offset);

  Stream<ExploreContentDTO?> exploreContentStream();

  void dispose();
}
