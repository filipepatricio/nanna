import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/result_item/mapper/result_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/result_item/result_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryDTOMapper extends Mapper<CategoryDTO, Category> {
  final ResultItemDTOMapper _resultItemDTOMapper;

  CategoryDTOMapper(
    this._resultItemDTOMapper,
  );

  @override
  Category call(CategoryDTO data) => Category(
        name: data.name,
        id: data.id,
        slug: data.slug,
        icon: data.icon,
        items: data.items.map<ResultItem>(_resultItemDTOMapper).toList(),
      );
}
