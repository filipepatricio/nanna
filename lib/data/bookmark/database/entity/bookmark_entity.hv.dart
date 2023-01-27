import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_data_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'bookmark_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.bookmarkEntity)
class BookmarkEntity {
  BookmarkEntity({
    required this.id,
    required this.data,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final BookmarkDataEntity data;
}
