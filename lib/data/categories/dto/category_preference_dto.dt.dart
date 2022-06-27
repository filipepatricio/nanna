import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_preference_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoryPreferenceDTO {
  const CategoryPreferenceDTO({
    required this.isPreferred,
    required this.category,
  });

  final bool isPreferred;
  final CategoryDTO category;

  factory CategoryPreferenceDTO.fromJson(Map<String, dynamic> json) => _$CategoryPreferenceDTOFromJson(json);
}
