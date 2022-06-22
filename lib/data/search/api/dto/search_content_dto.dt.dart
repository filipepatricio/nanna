import 'package:better_informed_mobile/data/result_item/dto/result_item_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_content_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class SearchContentDTO {
  final List<ResultItemDTO> search;

  SearchContentDTO(this.search);

  factory SearchContentDTO.fromJson(Map<String, dynamic> json) => _$SearchContentDTOFromJson(json);
}
