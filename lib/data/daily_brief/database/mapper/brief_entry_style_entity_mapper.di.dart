import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_style_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entry_style_type_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mapper/color_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryStyleEntityMapper implements BidirectionalMapper<BriefEntryStyleEntity, BriefEntryStyle> {
  BriefEntryStyleEntityMapper(
    this._colorMapper,
    this._briefEntryStyleTypeEntityMapper,
  );

  final OptionalColorMapper _colorMapper;
  final BriefEntryStyleTypeEntityMapper _briefEntryStyleTypeEntityMapper;

  @override
  BriefEntryStyleEntity from(BriefEntryStyle data) {
    return BriefEntryStyleEntity(
      color: _colorMapper.from(data.backgroundColor),
      type: _briefEntryStyleTypeEntityMapper.from(data.type),
    );
  }

  @override
  BriefEntryStyle to(BriefEntryStyleEntity data) {
    return BriefEntryStyle(
      backgroundColor: _colorMapper.to(data.color),
      type: _briefEntryStyleTypeEntityMapper.to(data.type),
    );
  }
}
