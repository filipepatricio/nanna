import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_pill_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'explore_content_dto.dt.g.dart';

@JsonSerializable()
class ExploreContentDTO {
  ExploreContentDTO(this.pillSection, this.highlightedSection);

  factory ExploreContentDTO.fromJson(Map<String, dynamic> json) => _$ExploreContentDTOFromJson(json);
  @JsonKey(name: 'pillSection')
  final List<ExploreContentPillDTO> pillSection;
  @JsonKey(name: 'highlightedSection')
  final List<ExploreContentAreaDTO> highlightedSection;

  Map<String, dynamic> toJson() => _$ExploreContentDTOToJson(this);
}
