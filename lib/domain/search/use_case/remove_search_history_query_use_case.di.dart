import 'package:better_informed_mobile/domain/search/search_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveSearchHistoryQueryUseCase {
  final SearchStore _searchStore;
  final UserStore _userStore;

  RemoveSearchHistoryQueryUseCase(
    this._searchStore,
    this._userStore,
  );

  Future<List<String>> call(String query) async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    final searchHistory = await _searchStore.getSearchHistory(userUuid: currentUserUuid);
    searchHistory.remove(query);
    _searchStore.setSearchHistory(searchHistory, userUuid: currentUserUuid);
    return searchHistory;
  }
}
