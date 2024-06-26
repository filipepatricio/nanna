import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoryItemsUseCase {
  const GetCategoryItemsUseCase(this._categoriesRepository);

  final CategoriesRepository _categoriesRepository;

  Future<List<CategoryItem>> call({required String slug, required int limit, required int offset}) async {
    final category = await _categoriesRepository.getPaginatedCategory(slug, limit, offset);
    return category.items;
  }
}
