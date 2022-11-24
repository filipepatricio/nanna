import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FollowCategoryUseCase {
  const FollowCategoryUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<CategoryPreference> call(Category category) => _userRepository.followCategory(category);
}
