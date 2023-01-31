import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookmarkLocalRepository, env: mockEnvs)
class BookmarkLocalRepositoryMock implements BookmarkLocalRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  Future<Synchronizable<Bookmark>?> load(String id) async {
    return null;
  }

  @override
  Future<BookmarkSortConfigName?> loadSortOption() async {
    return null;
  }

  @override
  Future<void> save(Synchronizable<Bookmark> bookmark) async {}

  @override
  Future<void> saveSortOption(BookmarkSortConfigName sort) async {}

  @override
  Future<List<Synchronizable<Bookmark>>> getAllBookmarks() async {
    return [];
  }

  @override
  Future<List<String>> getAllIds() async {
    return [];
  }
}
