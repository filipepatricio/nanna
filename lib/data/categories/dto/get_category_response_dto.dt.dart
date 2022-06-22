import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_category_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class GetCategoryResponseDTO {
  const GetCategoryResponseDTO(this.getCategory);

  final CategoryDTO getCategory;

  factory GetCategoryResponseDTO.fromJson(Map<String, dynamic> json) => _$GetCategoryResponseDTOFromJson(json);
}
