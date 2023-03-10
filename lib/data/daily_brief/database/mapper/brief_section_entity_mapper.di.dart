import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_section_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entry_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_subsection_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mapper/color_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_section.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefSectionEntityMapper implements BidirectionalMapper<BriefSectionEntity, BriefSection> {
  BriefSectionEntityMapper(
    this._briefEntryEntityMapper,
    this._briefSubsectionEntityMapper,
    this._optionalColorMapper,
  );

  final BriefEntryEntityMapper _briefEntryEntityMapper;
  final BriefSubsectionEntityMapper _briefSubsectionEntityMapper;
  final OptionalColorMapper _optionalColorMapper;

  @override
  BriefSectionEntity from(BriefSection data) {
    return data.map(
      entries: (data) => BriefSectionEntity.entries(
        BriefSectionEntriesEntity(
          title: data.title,
          backgroundColor: _optionalColorMapper.from(data.backgroundColor),
          entries: data.entries.map(_briefEntryEntityMapper.from).toList(),
        ),
      ),
      subsections: (data) => BriefSectionEntity.subsections(
        BriefSectionSubsectionEntity(
          title: data.title,
          backgroundColor: _optionalColorMapper.from(data.backgroundColor),
          subsections: data.subsections.map(_briefSubsectionEntityMapper.from).toList(),
        ),
      ),
      unknown: (_) => const BriefSectionEntity.unknown(),
    );
  }

  @override
  BriefSection to(BriefSectionEntity data) {
    return data.map(
      entries: (data) => BriefSection.entries(
        title: data.title,
        backgroundColor: _optionalColorMapper.to(data.backgroundColor),
        entries: data.entries.map(_briefEntryEntityMapper.to).toList(),
      ),
      subsections: (data) => BriefSection.subsections(
        title: data.title,
        backgroundColor: _optionalColorMapper.to(data.backgroundColor),
        subsections: data.subsections.map(_briefSubsectionEntityMapper.to).toList(),
      ),
      unknown: (data) => const BriefSection.unknown(),
    );
  }
}
