import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entry_item_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entry_style_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryEntityMapper implements BidirectionalMapper<BriefEntryEntity, BriefEntry> {
  BriefEntryEntityMapper(
    this._briefEntryStyleEntityMapper,
    this._briefEntryItemEntityMapper,
  );

  final BriefEntryStyleEntityMapper _briefEntryStyleEntityMapper;
  final BriefEntryItemEntityMapper _briefEntryItemEntityMapper;

  @override
  BriefEntryEntity from(BriefEntry data) {
    return BriefEntryEntity(
      item: _briefEntryItemEntityMapper.from(data.item),
      style: _briefEntryStyleEntityMapper.from(data.style),
      isNew: data.isNew,
    );
  }

  @override
  BriefEntry to(BriefEntryEntity data) {
    return BriefEntry(
      item: _briefEntryItemEntityMapper.to(data.item),
      style: _briefEntryStyleEntityMapper.to(data.style),
      isNew: data.isNew,
    );
  }
}
