import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadingListEntriesDTOMapper implements Mapper<EntryDTO, Entry> {
  final MediaItemDTOMapper _mediaItemDTOMapper;

  ReadingListEntriesDTOMapper(
    this._mediaItemDTOMapper,
  );

  @override
  Entry call(EntryDTO data) {
    return Entry(
      note: data.note,
      item: _mediaItemDTOMapper(data.item),
    );
  }
}
