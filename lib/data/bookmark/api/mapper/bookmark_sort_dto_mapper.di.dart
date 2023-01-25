import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_sort_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkSortDTOMapper implements Mapper<BookmarkSort, BookmarkSortDTO> {
  @override
  BookmarkSortDTO call(BookmarkSort data) {
    switch (data) {
      case BookmarkSort.added:
        return BookmarkSortDTO.added();
      case BookmarkSort.alphabetical:
        return BookmarkSortDTO.alphabetical();
      case BookmarkSort.updated:
        return BookmarkSortDTO.updated();
    }
  }
}
