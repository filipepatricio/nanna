import 'package:better_informed_mobile/domain/categories/data/category.dart';

abstract class CategoriesRepository {
  Future<List<Category>> getOnboardingCategories();

  Future<List<Category>> getFeaturedCategories();

  Stream<List<Category>> get categoriesStream;

  void setSelectedCategories(List<Category> categories);
}
