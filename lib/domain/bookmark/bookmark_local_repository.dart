import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';

abstract class BookmarkLocalRepository implements SynchronizableRepository<Bookmark> {
  Future<BookmarkSortConfigName?> loadSortOption();

  Future<void> saveSortOption(BookmarkSortConfigName sort);
}
