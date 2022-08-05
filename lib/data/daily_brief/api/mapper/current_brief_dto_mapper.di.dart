import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/current_brief_introduction_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/headline_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/relax_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentBriefDTOMapper implements Mapper<CurrentBriefDTO, CurrentBrief> {
  CurrentBriefDTOMapper(
    this._headlineDTOMapper,
    this._introductionDTOMapper,
    this._briefEntryDTOMapper,
    this._relaxDTOMapper,
  );

  final HeadlineDTOMapper _headlineDTOMapper;
  final CurrentBriefIntroductionDTOMapper _introductionDTOMapper;
  final BriefEntryDTOMapper _briefEntryDTOMapper;
  final RelaxDTOMapper _relaxDTOMapper;

  @override
  CurrentBrief call(CurrentBriefDTO data) {
    final introduction = data.introduction;

    return CurrentBrief(
      id: data.id,
      greeting: _headlineDTOMapper(data.greeting),
      introduction: introduction == null ? null : _introductionDTOMapper(introduction),
      date: DateTime.parse(data.date),
      entries: data.entries.map<BriefEntry>(_briefEntryDTOMapper).toList(),
      relax: _relaxDTOMapper(data.relax),
    );
  }
}
