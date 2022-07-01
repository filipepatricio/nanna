import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoryPreferencesUseCase {
  const GetCategoryPreferencesUseCase(this._categoriesRepository);

  final CategoriesRepository _categoriesRepository;

  Future<List<CategoryPreference>> call() => _categoriesRepository.getCategoryPreferences();
}
