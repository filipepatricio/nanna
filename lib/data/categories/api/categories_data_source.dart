import 'package:better_informed_mobile/data/categories/dto/onboarding_categories_response_dto.dt.dart';

abstract class CategoriesDataSource {
  Future<OnboardingCategoriesResponseDTO> getOnboardingCategories();
}
