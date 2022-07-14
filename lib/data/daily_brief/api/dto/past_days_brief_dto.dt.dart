import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'past_days_brief_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class PastDaysBriefDTO {
  PastDaysBriefDTO(
    this.brief,
    this.date,
  );

  factory PastDaysBriefDTO.fromJson(Map<String, dynamic> json) => _$PastDaysBriefDTOFromJson(json);

  final CurrentBriefDTO? brief;
  final DateTime date;
}
