import 'package:better_informed_mobile/domain/search/search_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

const maxElements = 10;

@injectable
class AddSearchHistoryQueryUseCase {
  AddSearchHistoryQueryUseCase(
    this._searchStore,
    this._userStore,
  );
  final SearchStore _searchStore;
  final UserStore _userStore;

  Future<void> call(String query) async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    final searchHistory = await _searchStore.getSearchHistory(userUuid: currentUserUuid);
    if (searchHistory.contains(query)) {
      return;
    }
    searchHistory.insert(0, query);
    if (searchHistory.length > maxElements) {
      searchHistory.removeLast();
    }
    return _searchStore.setSearchHistory(searchHistory, userUuid: currentUserUuid);
  }
}
