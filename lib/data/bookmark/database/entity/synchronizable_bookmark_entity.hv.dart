import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:hive/hive.dart';

part 'synchronizable_bookmark_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.synchronizableBookmarkEntity)
class SynchronizableBookmarkEntity extends SynchronizableEntity<BookmarkEntity> {
  SynchronizableBookmarkEntity({
    required super.data,
    required super.dataId,
    required super.createdAt,
    required super.synchronizedAt,
    required super.expirationDate,
  });
}
