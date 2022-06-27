import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_preference_dto.dt.dart';

abstract class CategoriesDataSource {
  Future<CategoriesDTO> getOnboardingCategories();

  Future<CategoriesDTO> getFeaturedCategories();

  Future<List<CategoryPreferenceDTO>> getCategoryPreferences();

  Future<CategoryDTO> getPaginatedCategory(String slug, int limit, int offset);
}
