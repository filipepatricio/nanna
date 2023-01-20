import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookmarkLocalRepository, env: mockEnvs)
class BookmarkLocalRepositoryMock implements BookmarkLocalRepository {
  @override
  Future<void> deleteBookmark(String id) async {}

  @override
  Future<Bookmark?> loadBookmark(String id) async {
    return null;
  }

  @override
  Future<BookmarkSortConfigName?> loadSortOption() async {
    return null;
  }

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {}

  @override
  Future<void> saveSortOption(BookmarkSortConfigName sort) async {}
}
