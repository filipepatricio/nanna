import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_data_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkEntityMapper implements BidirectionalMapper<BookmarkEntity, Bookmark> {
  BookmarkEntityMapper(this._bookmarkDataEntityMapper);

  final BookmarkDataEntityMapper _bookmarkDataEntityMapper;

  @override
  BookmarkEntity from(Bookmark data) {
    return BookmarkEntity(
      id: data.id,
      data: _bookmarkDataEntityMapper.from(data.data),
    );
  }

  @override
  Bookmark to(BookmarkEntity data) {
    return Bookmark(
      data.id,
      _bookmarkDataEntityMapper.to(data.data),
    );
  }
}
