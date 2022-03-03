import 'package:better_informed_mobile/data/bookmark/dto/bookmark_order_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkOrderDTOMapper implements Mapper<BookmarkOrder, BookmarkOrderDTO> {
  @override
  BookmarkOrderDTO call(BookmarkOrder data) {
    switch (data) {
      case BookmarkOrder.ascending:
        return BookmarkOrderDTO.ascending();
      case BookmarkOrder.descending:
        return BookmarkOrderDTO.descending();
    }
  }
}
