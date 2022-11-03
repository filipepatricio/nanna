import 'package:better_informed_mobile/data/common/dto/curator_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'curation_info_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CurationInfoDTO {
  CurationInfoDTO(this.byline, this.curator);

  factory CurationInfoDTO.fromJson(Map<String, dynamic> json) => _$CurationInfoDTOFromJson(json);

  final String byline;
  final CuratorDTO curator;
}
