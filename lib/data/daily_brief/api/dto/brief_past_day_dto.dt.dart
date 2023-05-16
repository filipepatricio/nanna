import 'package:json_annotation/json_annotation.dart';

part 'brief_past_day_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BriefPastDayDTO {
  BriefPastDayDTO(this.date, this.hasBrief);

  factory BriefPastDayDTO.fromJson(Map<String, dynamic> json) => _$BriefPastDayDTOFromJson(json);

  factory BriefPastDayDTO.empty(String date) => BriefPastDayDTO(date, false);

  final String date;
  final bool hasBrief;
}
