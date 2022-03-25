import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';

abstract class BookmarkLocalRepository {
  Future<BookmarkSortConfigName?> loadSortOption();

  Future<void> saveSortOption(BookmarkSortConfigName sort);
}
