import 'package:better_informed_mobile/data/categories/dto/category_preference_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_preferences_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CategoryPreferencesResponseDTO {
  const CategoryPreferencesResponseDTO(this.getCategoryPreferences);

  final List<CategoryPreferenceDTO>? getCategoryPreferences;

  factory CategoryPreferencesResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$CategoryPreferencesResponseDTOFromJson(json);
}
