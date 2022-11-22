import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoryPreferencesUseCase {
  const GetCategoryPreferencesUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<List<CategoryPreference>> call() => _userRepository.getCategoryPreferences();
}
