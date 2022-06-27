import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoriesDTO {
  const CategoriesDTO(this.categories);

  factory CategoriesDTO.fromJson(Map<String, dynamic> json) => _$CategoriesDTOFromJson(json);

  final List<CategoryDTO> categories;
}
