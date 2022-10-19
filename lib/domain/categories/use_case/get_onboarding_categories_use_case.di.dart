import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOnboardingCategoriesUseCase {
  const GetOnboardingCategoriesUseCase(this._categoriesRepository);

  final CategoriesRepository _categoriesRepository;

  Future<List<Category>> call() => _categoriesRepository.getOnboardingCategories();

  Stream<List<Category>> get stream => _categoriesRepository.categoriesStream;
}
