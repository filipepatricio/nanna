// ignore_for_file: unused_field

import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_sort_config_name_entity.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_sort_config_name_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/synchronizable_bookmark_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:hive/hive.dart';

const _sortBoxName = 'bookmark_sort';
const _sortKey = 'entity';

const _bookmarkBoxName = 'bookmark';

class BookmarkHiveLocalRepository implements BookmarkLocalRepository {
  BookmarkHiveLocalRepository._(
    this._bookmarkSortConfigNameEntityMapper,
    this._synchronizableBookmarkEntityMapper,
    this._bookmarkBox,
    this._sortBox,
  );

  final BookmarkSortConfigNameEntityMapper _bookmarkSortConfigNameEntityMapper;
  final SynchronizableBookmarkEntityMapper _synchronizableBookmarkEntityMapper;

  final LazyBox<SynchronizableEntity<BookmarkEntity>> _bookmarkBox;
  final Box<String> _sortBox;

  static Future<BookmarkHiveLocalRepository> create(
    BookmarkSortConfigNameEntityMapper bookmarkSortConfigNameEntityMapper,
    SynchronizableBookmarkEntityMapper synchronizableBookmarkEntityMapper,
  ) async {
    final bookmarkBox = await Hive.openLazyBox<SynchronizableEntity<BookmarkEntity>>(_bookmarkBoxName);
    final sortBox = await Hive.openBox<String>(_sortBoxName);
    return BookmarkHiveLocalRepository._(
      bookmarkSortConfigNameEntityMapper,
      synchronizableBookmarkEntityMapper,
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
  Future<void> delete(String id) async {
    // await _bookmarkBox.delete(id);
  }

  @override
  Future<Synchronizable<Bookmark>?> load(String id) async {
    // final entity = await _bookmarkBox.get(id);
    // if (entity == null) return null;

    // return _synchronizableBookmarkEntityMapper.to(entity);
    return null;
  }

  @override
  Future<void> save(Synchronizable<Bookmark> bookmark) async {
    // final entity = _synchronizableBookmarkEntityMapper.from(bookmark);
    // await _bookmarkBox.put(entity.dataId, entity);
  }

  @override
  Future<List<Synchronizable<Bookmark>>> getAllBookmarks() async {
    // final keys = _bookmarkBox.keys;
    // final entities = await Stream.fromIterable(keys)
    //     .asyncMap((value) => _bookmarkBox.get(value))
    //     .whereType<SynchronizableBookmarkEntity>()
    //     .toList();
    // return entities.map(_synchronizableBookmarkEntityMapper.to).toList();
    return [];
  }

  @override
  Future<List<String>> getAllIds() async {
    // return _bookmarkBox.keys.cast<String>().toList();
    return [];
  }
}
