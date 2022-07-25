import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePreferredCategoriesUseCase {
  const UpdatePreferredCategoriesUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<bool> call(List<Category> categories) => _userRepository.updatePreferredCategories(categories);
}
