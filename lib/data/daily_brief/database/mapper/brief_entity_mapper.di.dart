import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_introduction_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_section_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/headline_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/relax_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntityMapper implements BidirectionalMapper<BriefEntity, Brief> {
  BriefEntityMapper(
    this._headlineEntityMapper,
    this._briefIntroductionEntityMapper,
    this._relaxEntityMapper,
    this._briefSectionEntityMapper,
  );

  final HeadlineEntityMapper _headlineEntityMapper;
  final BriefIntroductionEntityMapper _briefIntroductionEntityMapper;
  final RelaxEntityMapper _relaxEntityMapper;
  final BriefSectionEntityMapper _briefSectionEntityMapper;

  @override
  BriefEntity from(Brief data) {
    final introduction = data.introduction;

    return BriefEntity(
      id: data.id,
      unseenCount: data.unseenCount,
      date: data.date.toIso8601String(),
      greeting: _headlineEntityMapper.from(data.greeting),
      introduction: introduction != null ? _briefIntroductionEntityMapper.from(introduction) : null,
      relax: _relaxEntityMapper.from(data.relax),
      sections: data.sections.map(_briefSectionEntityMapper.from).toList(),
    );
  }

  @override
  Brief to(BriefEntity data) {
    final introduction = data.introduction;

    return Brief(
      id: data.id,
      unseenCount: data.unseenCount,
      date: DateTime.parse(data.date),
      greeting: _headlineEntityMapper.to(data.greeting),
      introduction: introduction != null ? _briefIntroductionEntityMapper.to(introduction) : null,
      relax: _relaxEntityMapper.to(data.relax),
      sections: data.sections.map(_briefSectionEntityMapper.to).toList(),
    );
  }
}
