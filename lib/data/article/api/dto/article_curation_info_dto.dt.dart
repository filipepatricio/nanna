import 'package:better_informed_mobile/data/topic/api/dto/curator_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_curation_info_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ArticleCurationInfoDTO {
  ArticleCurationInfoDTO(this.byline, this.curator);

  factory ArticleCurationInfoDTO.fromJson(Map<String, dynamic> json) => _$ArticleCurationInfoDTOFromJson(json);

  final String byline;
  final CuratorDTO curator;
}
