import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entry_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/entry_style_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/media_item_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicEntryEntityMapper extends BidirectionalMapper<TopicEntryEntity, Entry> {
  TopicEntryEntityMapper(
    this._entryStyleEntityMapper,
    this._mediaItemEntityMapper,
  );

  final EntryStyleEntityMapper _entryStyleEntityMapper;
  final MediaItemEntityMapper _mediaItemEntityMapper;

  @override
  TopicEntryEntity from(Entry data) {
    return TopicEntryEntity(
      note: data.note,
      item: _mediaItemEntityMapper.from(data.item),
      style: _entryStyleEntityMapper.from(data.style),
    );
  }

  @override
  Entry to(TopicEntryEntity data) {
    return Entry(
      note: data.note,
      item: _mediaItemEntityMapper.to(data.item),
      style: _entryStyleEntityMapper.to(data.style),
    );
  }
}
