import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_area_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentDTOMapper implements Mapper<ExploreContentDTO, ExploreContent> {
  final ExploreContentAreaDTOMapper _exploreContentAreaDTOMapper;

  ExploreContentDTOMapper(
    this._exploreContentAreaDTOMapper,
  );

  @override
  ExploreContent call(ExploreContentDTO data) {
    return ExploreContent(
      areas: data.exploreSection.map<ExploreContentArea>(_exploreContentAreaDTOMapper).toList(),
    );
  }
}
