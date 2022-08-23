import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_introduction_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_section_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/relax_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brief_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BriefDTO {
  const BriefDTO(
    this.id,
    this.greeting,
    this.introduction,
    this.date,
    this.relax,
    this.sections,
  );

  factory BriefDTO.fromJson(Map<String, dynamic> json) => _$BriefDTOFromJson(json);

  final String id;
  final String date;
  final HeadlineDTO greeting;
  final BriefIntroductionDTO? introduction;
  final List<BriefSectionDTO> sections;
  final RelaxDTO relax;

  List<BriefEntryDTO> get allEntries => sections
      .map<Iterable<BriefEntryDTO>>(
        (section) => section.map(
          entries: (sectionWithEntries) => sectionWithEntries.entries,
          subsections: (sectionWithSubsections) => sectionWithSubsections.subsections.expand(
            (subsection) => subsection.entries,
          ),
          unknown: (_) => [],
        ),
      )
      .whereType<BriefEntryDTO>()
      .toList();
}
