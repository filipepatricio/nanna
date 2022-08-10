import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_section_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_subsection_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_section.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_subsection.dart';
import 'package:better_informed_mobile/presentation/util/color_util.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefSectionDTOMapper implements Mapper<BriefSectionDTO, BriefSection> {
  const BriefSectionDTOMapper(
    this._briefEntryDTOMapper,
    this._briefSubsectionDTOMapper,
  );

  final BriefEntryDTOMapper _briefEntryDTOMapper;
  final BriefSubsectionDTOMapper _briefSubsectionDTOMapper;

  @override
  BriefSection call(BriefSectionDTO data) {
    return data.map(
      entries: (section) => BriefSection.entries(
        title: section.title,
        backgroundColor: section.backgroundColor != null ? HexColor(section.backgroundColor!) : null,
        entries: section.entries.map<BriefEntry>(_briefEntryDTOMapper).toList(),
      ),
      subsections: (section) => BriefSection.subsections(
        title: section.title,
        backgroundColor: section.backgroundColor != null ? HexColor(section.backgroundColor!) : null,
        subsections: section.subsections.map<BriefSubsection>(_briefSubsectionDTOMapper).toList(),
      ),
      unknown: (section) => const BriefSection.unknown(),
    );
  }
}
