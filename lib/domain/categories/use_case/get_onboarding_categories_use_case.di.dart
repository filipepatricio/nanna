import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOnboardingCategoriesUseCase {
  const GetOnboardingCategoriesUseCase(this._onboardingRepository);

  final CategoriesRepository _onboardingRepository;

  Future<List<Category>> call() => _onboardingRepository.getOnboardingCategories();

  Stream<List<Category>> get stream => _onboardingRepository.categoriesStream;
}
