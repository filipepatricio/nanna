import 'package:better_informed_mobile/data/daily_brief/api/dto/category_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryDTOMapper implements Mapper<CategoryDTO, Category> {
  @override
  Category call(CategoryDTO data) {
    return Category(
      name: data.name,
    );
  }
}
