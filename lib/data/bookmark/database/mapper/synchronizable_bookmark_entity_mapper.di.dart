import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/synchronizable_bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/synchronization/database/mapper/synchronziable_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizableBookmarkEntityMapper extends SynchronizableEntityMapper<BookmarkEntity, Bookmark> {
  SynchronizableBookmarkEntityMapper(BookmarkEntityMapper bookmarkEntityMapper) : super(bookmarkEntityMapper);

  @override
  SynchronizableEntity<BookmarkEntity> createEntity({
    required BookmarkEntity? data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  }) {
    return SynchronizableBookmarkEntity(
      data: data,
      dataId: dataId,
      createdAt: createdAt,
      synchronizedAt: synchronizedAt,
      expirationDate: expirationDate,
    );
  }
}
