import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_filter_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkFilterDTOMapper implements Mapper<BookmarkFilter, BookmarkFilterDTO> {
  @override
  BookmarkFilterDTO call(BookmarkFilter data) {
    switch (data) {
      case BookmarkFilter.all:
        return BookmarkFilterDTO.all();
      case BookmarkFilter.article:
        return BookmarkFilterDTO.article();
      case BookmarkFilter.topic:
        return BookmarkFilterDTO.topic();
    }
  }
}
