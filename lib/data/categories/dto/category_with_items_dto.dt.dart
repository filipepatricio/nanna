import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_item_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_with_items_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoryWithItemsDTO extends CategoryDTO {
  CategoryWithItemsDTO({
    required super.name,
    required super.id,
    required super.slug,
    required super.icon,
    required super.color,
    required this.items,
  });

  factory CategoryWithItemsDTO.fromJson(Map<String, dynamic> json) => _$CategoryWithItemsDTOFromJson(json);

  @JsonKey(defaultValue: [])
  final List<CategoryItemDTO> items;
}
