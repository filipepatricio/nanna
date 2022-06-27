import 'package:better_informed_mobile/domain/search/search_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveSearchHistoryQueryUseCase {
  RemoveSearchHistoryQueryUseCase(
    this._searchStore,
    this._userStore,
  );
  final SearchStore _searchStore;
  final UserStore _userStore;

  Future<List<String>> call(String query) async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    final searchHistory = await _searchStore.getSearchHistory(userUuid: currentUserUuid);
    searchHistory.remove(query);
    await _searchStore.setSearchHistory(searchHistory, userUuid: currentUserUuid);
    return searchHistory;
  }
}
