import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';

abstract class CategoriesRepository {
  Future<List<Category>> getOnboardingCategories();

  Future<List<CategoryPreference>> getCategoryPreferences();

  Future<List<Category>> getFeaturedCategories();

  Future<CategoryWithItems> getPaginatedCategory(String slug, int limit, int offset);

  Stream<List<Category>> get categoriesStream;

  void setSelectedCategories(List<Category> categories);
}
