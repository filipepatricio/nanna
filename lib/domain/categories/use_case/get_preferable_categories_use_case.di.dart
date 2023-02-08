import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPreferableCategoriesUseCase {
  const GetPreferableCategoriesUseCase(this._categoriesRepository);

  final CategoriesRepository _categoriesRepository;

  Future<List<Category>> call() => _categoriesRepository.getPreferableCategories();

  Stream<List<Category>> get stream => _categoriesRepository.categoriesStream;
}
