import 'package:better_informed_mobile/data/search/store/search_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _searchHistoryKey = 'searchHistoryKey';
const _hiveBoxName = 'searchBox';

@LazySingleton(as: SearchDatabase, env: liveEnvs)
class SearchHiveDatabase implements SearchDatabase {
  Future<Box<dynamic>> _openUserBox(String userUuid, String hiveBoxName) async {
    final box = await Hive.openBox('${userUuid}_$hiveBoxName');
    return box;
  }

  @override
  Future<List<String>> getSearchHistory({required String userUuid}) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    final searchHistory = box.get(_searchHistoryKey) as List<String>?;
    return searchHistory ?? [];
  }

  @override
  Future<void> setSearchHistory(List<String> searchHistory, {required String userUuid}) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.put(_searchHistoryKey, searchHistory);
  }
}
