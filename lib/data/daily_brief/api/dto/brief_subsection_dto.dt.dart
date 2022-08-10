import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brief_subsection_dto.dt.g.dart';

@JsonSerializable()
class BriefSubsectionDTO {
  const BriefSubsectionDTO({
    required this.title,
    required this.entries,
  });

  factory BriefSubsectionDTO.fromJson(Map<String, dynamic> json) => _$BriefSubsectionDTOFromJson(json);

  final String title;
  final List<BriefEntryDTO> entries;

  Map<String, dynamic> toJson() => _$BriefSubsectionDTOToJson(this);
}
