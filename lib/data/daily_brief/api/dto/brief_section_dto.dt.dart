// ignore_for_file: invalid_annotation_target

import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_subsection_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_section_dto.dt.freezed.dart';
part 'brief_section_dto.dt.g.dart';

@Freezed(
  unionKey: '__typename',
  unionValueCase: FreezedUnionCase.pascal,
  fallbackUnion: unknownKey,
  toJson: false,
)
class BriefSectionDTO with _$BriefSectionDTO {
  @FreezedUnionValue('SectionWithEntries')
  const factory BriefSectionDTO.entries(
    String title,
    String? backgroundColor,
    List<BriefEntryDTO> entries,
  ) = BriefSectionDTOWithEntries;

  @FreezedUnionValue('SectionWithSubSections')
  const factory BriefSectionDTO.subsections(
    String title,
    String? backgroundColor,
    @JsonKey(name: 'sections') List<BriefSubsectionDTO> subsections,
  ) = BriefSectionDTOWithSubsections;

  @FreezedUnionValue(unknownKey)
  factory BriefSectionDTO.unknown() = _BriefSectionDTOUnknown;

  factory BriefSectionDTO.fromJson(Map<String, dynamic> json) => _$BriefSectionDTOFromJson(json);
}
