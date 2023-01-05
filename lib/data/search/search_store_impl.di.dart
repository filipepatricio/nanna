import 'package:better_informed_mobile/data/search/store/search_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/search/search_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchStore, env: defaultEnvs)
class SearchStoreImpl extends SearchStore {
  SearchStoreImpl(this._database);
  final SearchDatabase _database;

  @override
  Future<List<String>> getSearchHistory({required String userUuid}) async {
    return await _database.getSearchHistory(userUuid: userUuid);
  }

  @override
  Future<void> setSearchHistory(List<String> searchHistory, {required String userUuid}) async {
    await _database.setSearchHistory(searchHistory, userUuid: userUuid);
  }
}
