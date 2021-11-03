import 'package:better_informed_mobile/data/explore/api/explore_content_api_data_source.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExploreContentRepository)
class ExploreContentApiRepository implements ExploreContentRepository {
  final ExploreContentApiDataSource _dataSource;
  final ExploreContentDTOMapper _exploreContentDTOMapper;

  ExploreContentApiRepository(this._dataSource, this._exploreContentDTOMapper);

  @override
  Future<ExploreContent> getExploreContent() async {
    final dto = await _dataSource.getExploreContent();
    return _exploreContentDTOMapper(dto);
  }
}
