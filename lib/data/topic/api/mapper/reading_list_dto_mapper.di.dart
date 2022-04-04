import 'package:better_informed_mobile/data/daily_brief/api/mapper/reading_list_entries_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_dto.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadingListDTOMapper implements Mapper<ReadingListDTO, ReadingList> {
  final ReadingListEntriesDTOMapper _readingListEntriesDTOMapper;

  ReadingListDTOMapper(
    this._readingListEntriesDTOMapper,
  );

  @override
  ReadingList call(ReadingListDTO data) {
    return ReadingList(
      id: data.id,
      entries: data.entries.map<Entry>(_readingListEntriesDTOMapper).toList(),
    );
  }
}
