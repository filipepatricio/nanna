import 'package:better_informed_mobile/domain/categories/categories_local_repository.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsAddInterestsPageSeenUseCase {
  IsAddInterestsPageSeenUseCase(
    this._categoriesLocalRepository,
    this._userStore,
  );
  final CategoriesLocalRepository _categoriesLocalRepository;
  final UserStore _userStore;

  Future<bool> call() async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _categoriesLocalRepository.isAddInterestsPageSeen(currentUserUuid);
  }
}
