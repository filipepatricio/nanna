import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/presentation/util/color_util.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryDTOMapper extends Mapper<CategoryDTO, Category> {
  @override
  Category call(CategoryDTO data) {
    final color = data.color;
    return Category(
      name: data.name,
      id: data.id,
      slug: data.slug,
      icon: data.icon,
      color: color != null ? HexColor(color) : null,
    );
  }
}
