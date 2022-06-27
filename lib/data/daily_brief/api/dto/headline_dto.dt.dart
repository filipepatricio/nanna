import 'package:json_annotation/json_annotation.dart';

part 'headline_dto.dt.g.dart';

@JsonSerializable()
class HeadlineDTO {
  HeadlineDTO(this.headline, this.message, this.icon);

  factory HeadlineDTO.fromJson(Map<String, dynamic> json) => _$HeadlineDTOFromJson(json);
  final String headline;
  final String? message;
  final String? icon;

  Map<String, dynamic> toJson() => _$HeadlineDTOToJson(this);
}
