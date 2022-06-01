import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_introduction_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_brief_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CurrentBriefDTO {
  CurrentBriefDTO(
    this.id,
    this.greeting,
    this.introduction,
    this.goodbye,
    this.date,
    this.entries,
  );

  final String id;
  final HeadlineDTO greeting;
  final CurrentBriefIntroductionDTO? introduction;
  final HeadlineDTO goodbye;
  final String date;
  final List<BriefEntryDTO> entries;

  factory CurrentBriefDTO.fromJson(Map<String, dynamic> json) => _$CurrentBriefDTOFromJson(json);
}
