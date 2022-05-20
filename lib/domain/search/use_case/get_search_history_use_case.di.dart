import 'package:better_informed_mobile/domain/search/search_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSearchHistoryUseCase {
  final SearchStore _searchStore;
  final UserStore _userStore;

  GetSearchHistoryUseCase(
    this._searchStore,
    this._userStore,
  );

  Future<List<String>> call() async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _searchStore.getSearchHistory(userUuid: currentUserUuid);
  }
}
