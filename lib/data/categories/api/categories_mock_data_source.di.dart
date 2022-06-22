import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/dto/featured_categories_response_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/get_category_response_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/onboarding_categories_response_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoriesDataSource, env: mockEnvs)
class CategoriesMockDataSource implements CategoriesDataSource {
  @override
  Future<OnboardingCategoriesResponseDTO> getOnboardingCategories() async => OnboardingCategoriesResponseDTO(
        [
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
        ],
      );

  @override
  Future<FeaturedCategoriesResponseDTO> getFeaturedCategories() async => FeaturedCategoriesResponseDTO(
        [
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
          MockDTO.category,
        ],
      );

  @override
  Future<GetCategoryResponseDTO> getPaginatedCategory(String slug, int limit, int offset) async =>
      GetCategoryResponseDTO(MockDTO.category);
}
