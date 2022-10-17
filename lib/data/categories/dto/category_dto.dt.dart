import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoryDTO {
  const CategoryDTO({
    required this.name,
    required this.id,
    required this.slug,
    required this.icon,
    required this.color,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) => _$CategoryDTOFromJson(json);

  final String icon;
  final String id;
  final String name;
  final String slug;
  final String? color;
}
