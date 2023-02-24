import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';

abstract class BookmarkLocalRepository implements SynchronizableRepository<Bookmark> {
  Future<BookmarkSortConfigName?> loadSortOption();

  Future<void> saveSortOption(BookmarkSortConfigName sort);

  Future<List<Synchronizable<Bookmark>>> getAllBookmarks();

  Future<void> deleteAll();

  Future<void> saveSynchronizationTime(DateTime synchronizedAt);

  Future<DateTime?> loadLastSynchronizationTime();

  Future<BookmarkState> getBookmarkState(String slug);
}
