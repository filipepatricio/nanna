import 'package:better_informed_mobile/domain/categories/data/category.dart';

abstract class CategoriesRepository {
  Future<List<Category>> getOnboardingCategories();

  Stream<List<Category>> get categoriesStream;

  void setSelectedCategories(List<Category> categories);
}
