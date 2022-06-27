import 'package:json_annotation/json_annotation.dart';

part 'current_brief_introduction_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CurrentBriefIntroductionDTO {
  CurrentBriefIntroductionDTO({
    required this.text,
    required this.icon,
  });

  factory CurrentBriefIntroductionDTO.fromJson(Map<String, dynamic> json) {
    return _$CurrentBriefIntroductionDTOFromJson(json);
  }

  final String text;
  final String icon;
}
