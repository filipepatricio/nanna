import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryMapper extends BidirectionalMapper<CategoryDTO, Category> {
  @override
  CategoryDTO from(Category data) => CategoryDTO(
        name: data.name,
        id: data.id,
        slug: data.id,
        icon: data.icon,
      );

  @override
  Category to(CategoryDTO data) => Category(
        name: data.name,
        id: data.id,
        slug: data.id,
        icon: data.icon,
      );
}
