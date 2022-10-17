import 'package:better_informed_mobile/data/categories/dto/category_with_items_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_with_items_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoriesWithItemsDTO {
  const CategoriesWithItemsDTO(this.categories);

  factory CategoriesWithItemsDTO.fromJson(Map<String, dynamic> json) => _$CategoriesWithItemsDTOFromJson(json);

  final List<CategoryWithItemsDTO> categories;
}
