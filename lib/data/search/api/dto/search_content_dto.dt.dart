import 'package:better_informed_mobile/data/search/api/dto/search_result_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_content_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class SearchContentDTO {
  final List<SearchResultDTO> search;

  SearchContentDTO(this.search);

  factory SearchContentDTO.fromJson(Map<String, dynamic> json) => _$SearchContentDTOFromJson(json);
}
