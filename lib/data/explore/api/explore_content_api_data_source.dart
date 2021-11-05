import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dart';

abstract class ExploreContentApiDataSource {
  Future<ExploreContentDTO> getExploreContent();
}
