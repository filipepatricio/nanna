import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/search/search_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchStore, env: mockEnvs)
class SearchStoreMock extends SearchStore {
  @override
  Future<List<String>> getSearchHistory({required String userUuid}) async {
    return ['world', 'ukraine', 'abc'];
  }

  @override
  Future<void> setSearchHistory(List<String> searchHistory, {required String userUuid}) async {}
}
