import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_introduction_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_section_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/headline_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/relax_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_section.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefDTOMapper implements Mapper<BriefDTO, Brief> {
  const BriefDTOMapper(
    this._headlineDTOMapper,
    this._introductionDTOMapper,
    this._briefSectionDTOMapper,
    this._relaxDTOMapper,
  );

  final HeadlineDTOMapper _headlineDTOMapper;
  final BriefIntroductionDTOMapper _introductionDTOMapper;
  final BriefSectionDTOMapper _briefSectionDTOMapper;
  final RelaxDTOMapper _relaxDTOMapper;

  @override
  Brief call(BriefDTO data) {
    final introduction = data.introduction;

    return Brief(
      id: data.id,
      unseenCount: data.unseenCount,
      greeting: _headlineDTOMapper(data.greeting),
      introduction: introduction == null ? null : _introductionDTOMapper(introduction),
      date: DateTime.parse(data.date),
      sections: data.sections.map<BriefSection>(_briefSectionDTOMapper).toList(),
      relax: _relaxDTOMapper(data.relax),
    );
  }
}
