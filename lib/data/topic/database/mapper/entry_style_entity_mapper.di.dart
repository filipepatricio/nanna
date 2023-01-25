import 'dart:ui';

import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/entry_style_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/entry_style_type_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:injectable/injectable.dart';

@injectable
class EntryStyleEntityMapper implements BidirectionalMapper<EntryStyleEntity, EntryStyle> {
  EntryStyleEntityMapper(this._entryStyleTypeEntityMapper);

  final EntryStyleTypeEntityMapper _entryStyleTypeEntityMapper;

  @override
  EntryStyleEntity from(EntryStyle data) {
    return EntryStyleEntity(
      color: data.color.value,
      type: _entryStyleTypeEntityMapper.from(data.type),
    );
  }

  @override
  EntryStyle to(EntryStyleEntity data) {
    return EntryStyle(
      color: Color(data.color),
      type: _entryStyleTypeEntityMapper.to(data.type),
    );
  }
}
