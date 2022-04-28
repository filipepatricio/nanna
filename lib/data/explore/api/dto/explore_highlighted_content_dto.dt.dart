import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_pill_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'explore_highlighted_content_dto.dt.g.dart';

@JsonSerializable()
class ExploreHighlightedContentDTO {
  @JsonKey(name: 'pillSection')
  final List<ExploreContentPillDTO> pillSection;
  @JsonKey(name: 'highlightedSection')
  final List<ExploreContentAreaDTO> highlightedSection;

  ExploreHighlightedContentDTO(this.pillSection, this.highlightedSection);

  factory ExploreHighlightedContentDTO.fromJson(Map<String, dynamic> json) =>
      _$ExploreHighlightedContentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreHighlightedContentDTOToJson(this);
}
