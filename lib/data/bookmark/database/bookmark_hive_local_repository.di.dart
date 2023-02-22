import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_sort_config_name_entity.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/synchronizable_bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_sort_config_name_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/synchronizable_bookmark_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

const _bookmarkedSlugsBoxName = 'bookmark_slugs';
const _miscellaneousBoxName = 'bookmark_sort';
const _sortKey = 'entity';
const _synchronizationTimeKey = 'synchronization_time';

const _bookmarkBoxName = 'bookmark';

class BookmarkHiveLocalRepository implements BookmarkLocalRepository {
  BookmarkHiveLocalRepository._(
    this._bookmarkSortConfigNameEntityMapper,
    this._synchronizableBookmarkEntityMapper,
    this._bookmarkBox,
    this._miscellaneousBox,
    this._bookmarkedSlugsBox,
  );

  final BookmarkSortConfigNameEntityMapper _bookmarkSortConfigNameEntityMapper;
  final SynchronizableBookmarkEntityMapper _synchronizableBookmarkEntityMapper;

  final LazyBox<SynchronizableEntity<BookmarkEntity>> _bookmarkBox;
  final Box<String> _miscellaneousBox;
  final Box<String> _bookmarkedSlugsBox;

  static Future<BookmarkHiveLocalRepository> create(
    BookmarkSortConfigNameEntityMapper bookmarkSortConfigNameEntityMapper,
    SynchronizableBookmarkEntityMapper synchronizableBookmarkEntityMapper,
  ) async {
    final bookmarkBox = await Hive.openLazyBox<SynchronizableEntity<BookmarkEntity>>(_bookmarkBoxName);
    final sortBox = await Hive.openBox<String>(_miscellaneousBoxName);
    final bookmarkedSlugsBox = await Hive.openBox<String>(_bookmarkedSlugsBoxName);
    return BookmarkHiveLocalRepository._(
      bookmarkSortConfigNameEntityMapper,
      synchronizableBookmarkEntityMapper,
      bookmarkBox,
      sortBox,
      bookmarkedSlugsBox,
    );
  }

  @override
  Future<BookmarkSortConfigName?> loadSortOption() async {
    final entity = _miscellaneousBox.get(_sortKey);
    if (entity == null) return null;

    return _bookmarkSortConfigNameEntityMapper.from(BookmarkSortConfigNameEntity(entity));
  }

  @override
  Future<void> saveSortOption(BookmarkSortConfigName sort) async {
    final entity = _bookmarkSortConfigNameEntityMapper.to(sort);
    await _miscellaneousBox.put(_sortKey, entity.value);
  }

  @override
  Future<DateTime?> loadLastSynchronizationTime() async {
    final entity = _miscellaneousBox.get(_synchronizationTimeKey);
    if (entity == null) return null;

    return DateTime.parse(entity);
  }

  @override
  Future<void> saveSynchronizationTime(DateTime synchronizedAt) async {
    await _miscellaneousBox.put(_synchronizationTimeKey, synchronizedAt.toIso8601String());
  }

  @override
  Future<void> delete(String id) async {
    final bookmark = await load(id);
    final slug = bookmark?.data?.slug;
    if (slug != null) await _bookmarkedSlugsBox.delete(slug);

    await _bookmarkBox.delete(id);
  }

  @override
  Future<Synchronizable<Bookmark>?> load(String id) async {
    final entity = await _bookmarkBox.get(id);
    if (entity == null) return null;

    return _synchronizableBookmarkEntityMapper.to(entity);
  }

  @override
  Future<void> save(Synchronizable<Bookmark> bookmark) async {
    final entity = _synchronizableBookmarkEntityMapper.from(bookmark);
    await _bookmarkBox.put(entity.dataId, entity);

    final slug = bookmark.data?.slug;
    if (slug != null) await _bookmarkedSlugsBox.put(bookmark.data?.slug, entity.dataId);
  }

  @override
  Future<List<Synchronizable<Bookmark>>> getAllBookmarks() async {
    final keys = _bookmarkBox.keys;
    final entities = await Stream.fromIterable(keys)
        .asyncMap((value) => _bookmarkBox.get(value))
        .whereType<SynchronizableBookmarkEntity>()
        .toList();
    return entities.map(_synchronizableBookmarkEntityMapper.to).toList();
  }

  @override
  Future<BookmarkState> getBookmarkState(String slug) async {
    final bookmarkId = _bookmarkedSlugsBox.get(slug);

    if (bookmarkId != null) return BookmarkState.bookmarked(bookmarkId);
    return BookmarkState.notBookmarked();
  }

  @override
  Future<List<String>> getAllIds() async {
    return _bookmarkBox.keys.cast<String>().toList();
  }

  @override
  Future<void> deleteAll() async {
    await _miscellaneousBox.clear();
    await _bookmarkBox.clear();
  }
}

extension on Bookmark {
  String? get slug => data.mapOrNull(
        article: (article) => article.article.slug,
        topic: (topic) => topic.topic.slug,
      );
}
