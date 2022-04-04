import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_style_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadingListEntriesDTOMapper implements Mapper<EntryDTO, Entry> {
  final MediaItemDTOMapper _mediaItemDTOMapper;
  final EntryStyleDTOMapper _entryStyleDTOMapper;

  ReadingListEntriesDTOMapper(
    this._mediaItemDTOMapper,
    this._entryStyleDTOMapper,
  );

  @override
  Entry call(EntryDTO data) {
    return Entry(
      note: data.note,
      item: _mediaItemDTOMapper(data.item),
      style: _entryStyleDTOMapper(data.style),
    );
  }
}
