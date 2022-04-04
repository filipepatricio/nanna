import 'package:better_informed_mobile/data/bookmark/database/bookmark_local_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/entity/bookmark_sort_config_name_entity.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookmarkLocalDataSource, env: mockEnvs)
class BookmarkLocalMockDataSource implements BookmarkLocalDataSource {
  @override
  Future<BookmarkSortConfigNameEntity?> loadBookmarkSortConfig() async {
    return null;
  }

  @override
  Future<void> saveBookmarkSortConfig(BookmarkSortConfigNameEntity entity) async {}
}
