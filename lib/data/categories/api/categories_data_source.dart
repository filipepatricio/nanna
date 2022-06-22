import 'package:better_informed_mobile/data/categories/dto/featured_categories_response_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/get_category_response_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/onboarding_categories_response_dto.dt.dart';

abstract class CategoriesDataSource {
  Future<OnboardingCategoriesResponseDTO> getOnboardingCategories();

  Future<FeaturedCategoriesResponseDTO> getFeaturedCategories();

  Future<GetCategoryResponseDTO> getPaginatedCategory(String slug, int limit, int offset);
}
