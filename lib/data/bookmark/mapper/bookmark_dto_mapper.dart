import 'package:better_informed_mobile/data/bookmark/dto/bookmark_dto.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_data_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkDTOMapper implements Mapper<BookmarkDTO, Bookmark> {
  BookmarkDTOMapper(this._bookmarkDataDTOMapper);

  final BookmarkDataDTOMapper _bookmarkDataDTOMapper;

  @override
  Bookmark call(BookmarkDTO data) {
    return Bookmark(
      data.id,
      _bookmarkDataDTOMapper(data.entity),
    );
  }
}
