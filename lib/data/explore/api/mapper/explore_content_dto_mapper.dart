import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_area_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentDTOMapper implements Mapper<ExploreContentDTO, ExploreContent> {
  final ExploreContentAreaDTOMapper _exploreContentAreaDTOMapper;

  ExploreContentDTOMapper(this._exploreContentAreaDTOMapper);

  @override
  ExploreContent call(ExploreContentDTO data) {
    return ExploreContent(
      areas: data.data.map<ExploreContentArea>(_exploreContentAreaDTOMapper).toList(),
    );
  }
}
