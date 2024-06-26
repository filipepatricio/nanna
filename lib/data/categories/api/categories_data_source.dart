import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_with_items_dto.dt.dart';

abstract class CategoriesDataSource {
  Future<CategoriesDTO> getPreferableCategories();

  Future<CategoriesDTO> getFeaturedCategories();

  Future<CategoryWithItemsDTO> getPaginatedCategory(String slug, int limit, int offset);
}
