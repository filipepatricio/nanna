import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_categories_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class OnboardingCategoriesResponseDTO {
  const OnboardingCategoriesResponseDTO(this.getOnboardingCategories);

  final List<CategoryDTO>? getOnboardingCategories;

  factory OnboardingCategoriesResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$OnboardingCategoriesResponseDTOFromJson(json);
}
