import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';

class BookmarkSortConfig {
  const BookmarkSortConfig(this.sort, this.order);

  final BookmarkSort sort;
  final BookmarkOrder order;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is BookmarkSortConfig && sort == other.sort && order == other.order);
  }

  @override
  int get hashCode => Object.hash(sort.hashCode, order.hashCode);
}

enum BookmarkSortConfigName { lastUpdated, lastAdded, alphabeticalAsc, alphabeticalDesc }

const bookmarkConfigMap = {
  BookmarkSortConfigName.lastAdded: BookmarkSortConfig(
    BookmarkSort.added,
    BookmarkOrder.descending,
  ),
  BookmarkSortConfigName.lastUpdated: BookmarkSortConfig(
    BookmarkSort.updated,
    BookmarkOrder.descending,
  ),
  BookmarkSortConfigName.alphabeticalAsc: BookmarkSortConfig(
    BookmarkSort.alphabetical,
    BookmarkOrder.ascending,
  ),
  BookmarkSortConfigName.alphabeticalDesc: BookmarkSortConfig(
    BookmarkSort.alphabetical,
    BookmarkOrder.descending,
  ),
};

