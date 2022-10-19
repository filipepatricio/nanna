import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetSelectedOnboardingCategoriesStreamUseCase {
  SetSelectedOnboardingCategoriesStreamUseCase(this._onboardingRepository);

  final CategoriesRepository _onboardingRepository;

  void call(List<Category> categories) => _onboardingRepository.setSelectedCategories(categories);
}
