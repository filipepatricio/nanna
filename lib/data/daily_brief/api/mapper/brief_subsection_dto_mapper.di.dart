import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_subsection_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_subsection.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefSubsectionDTOMapper implements Mapper<BriefSubsectionDTO, BriefSubsection> {
  const BriefSubsectionDTOMapper(this._briefEntryDTOMapper);

  final BriefEntryDTOMapper _briefEntryDTOMapper;
  @override
  BriefSubsection call(BriefSubsectionDTO data) {
    return BriefSubsection(
      title: data.title,
      entries: data.entries.map<BriefEntry>(_briefEntryDTOMapper).toList(),
    );
  }
}
