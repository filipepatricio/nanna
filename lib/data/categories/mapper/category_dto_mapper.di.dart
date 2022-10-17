import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/color_util.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryDTOMapper extends Mapper<CategoryDTO, Category> {
  CategoryDTOMapper(
    this._categoryItemDTOMapper,
  );

  final CategoryItemDTOMapper _categoryItemDTOMapper;

  @override
  Category call(CategoryDTO data) {
    final color = data.color;
    return Category(
      name: data.name,
      id: data.id,
      slug: data.slug,
      icon: data.icon,
      color: color != null ? HexColor(color) : null,
      items: data.items.map<CategoryItem>(_categoryItemDTOMapper).toList(),
    );
  }
}
