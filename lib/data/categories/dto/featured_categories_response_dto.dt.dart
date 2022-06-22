import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'featured_categories_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class FeaturedCategoriesResponseDTO {
  const FeaturedCategoriesResponseDTO(this.featuredCategories);

  @JsonKey(name: 'getFeaturedCategories', defaultValue: [])
  final List<CategoryDTO>? featuredCategories;

  factory FeaturedCategoriesResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$FeaturedCategoriesResponseDTOFromJson(json);
}
