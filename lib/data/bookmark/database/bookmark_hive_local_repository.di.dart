// ignore_for_file: unused_field

import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_sort_config_name_entity.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_sort_config_name_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:hive/hive.dart';

const _sortBoxName = 'bookmark_sort';
const _sortKey = 'entity';

const _bookmarkBoxName = 'bookmark';

class BookmarkHiveLocalRepository implements BookmarkLocalRepository {
  BookmarkHiveLocalRepository._(
    this._bookmarkSortConfigNameEntityMapper,
    this._bookmarkEntityMapper,
    this._bookmarkBox,
    this._sortBox,
  );

  final BookmarkSortConfigNameEntityMapper _bookmarkSortConfigNameEntityMapper;
  final BookmarkEntityMapper _bookmarkEntityMapper;

  final LazyBox<BookmarkEntity> _bookmarkBox;
  final Box<String> _sortBox;

  static Future<BookmarkHiveLocalRepository> create(
    BookmarkSortConfigNameEntityMapper bookmarkSortConfigNameEntityMapper,
    BookmarkEntityMapper bookmarkEntityMapper,
  ) async {
    final bookmarkBox = await Hive.openLazyBox<BookmarkEntity>(_bookmarkBoxName);
    final sortBox = await Hive.openBox<String>(_sortBoxName);
    return BookmarkHiveLocalRepository._(
      bookmarkSortConfigNameEntityMapper,
      bookmarkEntityMapper,
      bookmarkBox,
      sortBox,
    );
  }

  @override
  Future<BookmarkSortConfigName?> loadSortOption() async {
    final entity = _sortBox.get(_sortKey);
    if (entity == null) return null;

    return _bookmarkSortConfigNameEntityMapper.from(BookmarkSortConfigNameEntity(entity));
  }

  @override
  Future<void> saveSortOption(BookmarkSortConfigName sort) async {
    final entity = _bookmarkSortConfigNameEntityMapper.to(sort);
    await _sortBox.put(_sortKey, entity.value);
  }

  @override
  Future<void> deleteBookmark(String id) async {
    // await _bookmarkBox.delete(id);
  }

  @override
  Future<Bookmark?> loadBookmark(String id) async {
    // final entity = await _bookmarkBox.get(id);
    // if (entity == null) return null;

    // return _bookmarkEntityMapper.to(entity);
    return null;
  }

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {
    // final entity = _bookmarkEntityMapper.from(bookmark);
    // await _bookmarkBox.put(entity.id, entity);
  }
}
