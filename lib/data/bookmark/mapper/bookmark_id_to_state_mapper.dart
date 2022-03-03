import 'package:better_informed_mobile/data/bookmark/dto/bookmark_id_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkIdToStateMapper implements Mapper<BookmarkIdDTO?, BookmarkState> {
  @override
  BookmarkState call(BookmarkIdDTO? data) {
    if (data == null) {
      return BookmarkState.notBookmarked();
    }

    return BookmarkState.bookmarked(data.id);
  }
}
