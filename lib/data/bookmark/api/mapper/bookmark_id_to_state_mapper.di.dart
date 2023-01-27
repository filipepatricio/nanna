import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_id_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
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
