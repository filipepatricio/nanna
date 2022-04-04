import 'package:json_annotation/json_annotation.dart';

part 'headline_dto.dt.g.dart';

@JsonSerializable()
class HeadlineDTO {
  final String headline;
  final String? message;
  final String? icon;

  HeadlineDTO(this.headline, this.message, this.icon);

  factory HeadlineDTO.fromJson(Map<String, dynamic> json) => _$HeadlineDTOFromJson(json);

  Map<String, dynamic> toJson() => _$HeadlineDTOToJson(this);
}
