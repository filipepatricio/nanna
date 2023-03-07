import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_subsection_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entry_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_subsection.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefSubsectionEntityMapper implements BidirectionalMapper<BriefSubsectionEntity, BriefSubsection> {
  BriefSubsectionEntityMapper(this._briefEntryEntityMapper);

  final BriefEntryEntityMapper _briefEntryEntityMapper;

  @override
  BriefSubsectionEntity from(BriefSubsection data) {
    return BriefSubsectionEntity(
      title: data.title,
      entries: data.entries.map(_briefEntryEntityMapper.from).toList(),
    );
  }

  @override
  BriefSubsection to(BriefSubsectionEntity data) {
    return BriefSubsection(
      title: data.title,
      entries: data.entries.map(_briefEntryEntityMapper.to).toList(),
    );
  }
}
