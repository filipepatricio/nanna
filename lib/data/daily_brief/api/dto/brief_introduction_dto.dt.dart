import 'package:json_annotation/json_annotation.dart';

part 'brief_introduction_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BriefIntroductionDTO {
  const BriefIntroductionDTO({
    required this.text,
    required this.icon,
  });

  factory BriefIntroductionDTO.fromJson(Map<String, dynamic> json) {
    return _$BriefIntroductionDTOFromJson(json);
  }

  final String text;
  final String icon;
}
