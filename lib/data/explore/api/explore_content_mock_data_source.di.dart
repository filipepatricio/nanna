import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExploreContentApiDataSource, env: mockEnvs)
class ExploreMockDataSource implements ExploreContentApiDataSource {
  @override
  Future<ExploreContentDTO> getExploreContent() async {
    return MockDTO.exploreContent;
  }

  @override
  Future<ExploreContentAreaDTO> getPaginatedExploreArea(String id, int limit, int offset) async {
    return MockDTO.exploreContent.highlightedSection.firstWhere(
      (area) => area.id == id,
      orElse: () => MockDTO.exploreContent.highlightedSection.first,
    );
  }

  @override
  Stream<ExploreContentDTO?> exploreContentStream() async* {
    yield MockDTO.exploreContent;
  }

  @override
  @disposeMethod
  void dispose() {}
}
