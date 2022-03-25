import 'package:better_informed_mobile/data/bookmark/entity/bookmark_sort_config_name_entity.dart';

abstract class BookmarkLocalDataSource {
  Future<void> saveBookmarkSortConfig(BookmarkSortConfigNameEntity entity);

  Future<BookmarkSortConfigNameEntity?> loadBookmarkSortConfig();
}
