import 'package:better_informed_mobile/data/result_item/dto/result_item_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoryDTO {
  const CategoryDTO({
    required this.name,
    required this.id,
    required this.slug,
    required this.icon,
    required this.items,
  });

  final String icon;
  final String id;
  final String name;
  final String slug;
  @JsonKey(defaultValue: [])
  final List<ResultItemDTO> items;

  factory CategoryDTO.fromJson(Map<String, dynamic> json) => _$CategoryDTOFromJson(json);
}
