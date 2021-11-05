import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_section_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentDTOMapper implements Mapper<ExploreContentDTO, ExploreContent> {
  final ExploreContentSectionDTOMapper _exploreContentSectionDTOMapper;

  ExploreContentDTOMapper(this._exploreContentSectionDTOMapper);

  @override
  ExploreContent call(ExploreContentDTO data) {
    return ExploreContent(
      sections: data.data.map<ExploreContentSection>(_exploreContentSectionDTOMapper).toList(),
    );
  }
}
