import 'package:better_informed_mobile/data/explore/api/dto/explore_highlighted_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_area_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_pill_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_pill.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreHighlightedContentDTOMapper implements Mapper<ExploreHighlightedContentDTO, ExploreContent> {
  final ExploreContentPillDTOMapper _exploreContentPillDTOMapper;
  final ExploreContentAreaDTOMapper _exploreContentAreaDTOMapper;

  ExploreHighlightedContentDTOMapper(
    this._exploreContentPillDTOMapper,
    this._exploreContentAreaDTOMapper,
  );

  @override
  ExploreContent call(ExploreHighlightedContentDTO data) {
    return ExploreContent(
      pills: data.pillSection.map<ExploreContentPill>(_exploreContentPillDTOMapper).toList(),
      areas: data.highlightedSection.map<ExploreContentArea>(_exploreContentAreaDTOMapper).toList(),
    );
  }
}
