import 'package:better_informed_mobile/data/categories/dto/category_with_items_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:better_informed_mobile/presentation/util/color_util.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryWithItemsDTOMapper extends Mapper<CategoryWithItemsDTO, CategoryWithItems> {
  CategoryWithItemsDTOMapper(this._categoryItemDTOMapper);

  final CategoryItemDTOMapper _categoryItemDTOMapper;

  @override
  CategoryWithItems call(CategoryWithItemsDTO data) {
    final color = data.color;
    return CategoryWithItems(
      name: data.name,
      id: data.id,
      slug: data.slug,
      icon: data.icon,
      color: color != null ? HexColor(color) : null,
      items: data.items.map<CategoryItem>(_categoryItemDTOMapper).toList(),
    );
  }
}
