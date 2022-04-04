import 'package:better_informed_mobile/data/bookmark/database/bookmark_local_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_sort_config_name_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookmarkLocalRepository)
class BookmarkLocalRepositoryImpl implements BookmarkLocalRepository {
  BookmarkLocalRepositoryImpl(
    this._bookmarkLocalDataSource,
    this._bookmarkSortConfigNameEntityMapper,
  );

  final BookmarkLocalDataSource _bookmarkLocalDataSource;
  final BookmarkSortConfigNameEntityMapper _bookmarkSortConfigNameEntityMapper;

  @override
  Future<BookmarkSortConfigName?> loadSortOption() async {
    final entity = await _bookmarkLocalDataSource.loadBookmarkSortConfig();
    if (entity == null) return null;

    return _bookmarkSortConfigNameEntityMapper.from(entity);
  }

  @override
  Future<void> saveSortOption(BookmarkSortConfigName sort) async {
    final entity = _bookmarkSortConfigNameEntityMapper.to(sort);
    await _bookmarkLocalDataSource.saveBookmarkSortConfig(entity);
  }
}
