abstract class SearchStore {
  Future<List<String>> getSearchHistory({required String userUuid});

  Future<void> setSearchHistory(List<String> searchHistory, {required String userUuid});
}
