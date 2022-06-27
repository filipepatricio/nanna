import 'package:better_informed_mobile/data/categories/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryPreferenceDTOMapper extends Mapper<CategoryPreferenceDTO, CategoryPreference> {
  CategoryPreferenceDTOMapper(this._categoryDTOMapper);

  final CategoryDTOMapper _categoryDTOMapper;

  @override
  CategoryPreference call(CategoryPreferenceDTO data) => CategoryPreference(
        isPreferred: data.isPreferred,
        category: _categoryDTOMapper(data.category),
      );
}
