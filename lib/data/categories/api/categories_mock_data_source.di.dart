import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_with_items_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoriesDataSource, env: mockEnvs)
class CategoriesMockDataSource implements CategoriesDataSource {
  @override
  Future<CategoriesDTO> getPreferableCategories() async => MockDTO.categories;

  @override
  Future<CategoriesDTO> getFeaturedCategories() async => MockDTO.categories;

  @override
  Future<CategoryWithItemsDTO> getPaginatedCategory(String slug, int limit, int offset) async =>
      MockDTO.categoryWithItems;
}
