import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoriesDataSource, env: mockEnvs)
class CategoriesMockDataSource implements CategoriesDataSource {
  @override
  Future<CategoriesDTO> getOnboardingCategories() async => MockDTO.categories;

  @override
  Future<CategoriesDTO> getFeaturedCategories() async => MockDTO.categories;

  @override
  Future<CategoryDTO> getPaginatedCategory(String slug, int limit, int offset) async => MockDTO.category;

  @override
  Future<List<CategoryPreferenceDTO>> getCategoryPreferences() async => MockDTO.categoryPreferences;
}
