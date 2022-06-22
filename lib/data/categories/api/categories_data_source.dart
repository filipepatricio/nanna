import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';

abstract class CategoriesDataSource {
  Future<CategoriesDTO> getOnboardingCategories();
}
