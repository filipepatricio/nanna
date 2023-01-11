import 'package:better_informed_mobile/data/bookmark/database/bookmark_local_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/entity/bookmark_sort_config_name_entity.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

const _box = 'bookmark_sort';
const _key = 'entity';

@LazySingleton(as: BookmarkLocalDataSource, env: defaultEnvs)
class BookmarkLocalHiveDataSource implements BookmarkLocalDataSource {
  @override
  Future<BookmarkSortConfigNameEntity?> loadBookmarkSortConfig() async {
    final box = await Hive.openBox(_box);
    final value = box.get(_key) as String?;
    return value != null ? BookmarkSortConfigNameEntity(value) : null;
  }

  @override
  Future<void> saveBookmarkSortConfig(BookmarkSortConfigNameEntity entity) async {
    final box = await Hive.openBox(_box);
    await box.put(_key, entity.value);
  }
}
