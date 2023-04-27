import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_past_day_dto.dt.dart';
import 'package:clock/clock.dart';
import 'package:json_annotation/json_annotation.dart';

part 'briefs_wrapper_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BriefsWrapperDTO {
  const BriefsWrapperDTO(this.currentBrief, this.pastDays);

  factory BriefsWrapperDTO.fromJson(Map<String, dynamic> json) => _$BriefsWrapperDTOFromJson(json);

  factory BriefsWrapperDTO.withEmptyPastDays(Map<String, dynamic> json) {
    return BriefsWrapperDTO(
      BriefDTO.fromJson(json),
      _emptyPastDates(),
    );
  }

  @JsonKey(name: 'currentBrief')
  final BriefDTO currentBrief;
  @JsonKey(name: 'getPastDaysBriefs')
  final List<BriefPastDayDTO> pastDays;
}

List<BriefPastDayDTO> _emptyPastDates() {
  return List.generate(
    6,
    (index) => BriefPastDayDTO.empty(
      '${clock.now().subtract(Duration(days: index))}',
    ),
  )..sort((a, b) => a.date.compareTo(b.date));
}
