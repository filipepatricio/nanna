import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_past_day_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'briefs_wrapper_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BriefsWrapperDTO {
  BriefsWrapperDTO(this.currentBrief, this.pastDays);

  factory BriefsWrapperDTO.fromJson(Map<String, dynamic> json) => _$BriefsWrapperDTOFromJson(json);

  @JsonKey(name: 'currentBrief')
  final BriefDTO currentBrief;
  @JsonKey(name: 'getPastDaysBriefs')
  final List<BriefPastDayDTO> pastDays;
}
