import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'explore_content_dto.dt.g.dart';

@JsonSerializable()
class ExploreContentDTO {
  @JsonKey(name: 'getExploreSection')
  final List<ExploreContentAreaDTO> data;

  ExploreContentDTO(this.data);

  factory ExploreContentDTO.fromJson(Map<String, dynamic> json) => _$ExploreContentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreContentDTOToJson(this);
}
