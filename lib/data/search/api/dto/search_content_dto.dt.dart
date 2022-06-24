import 'package:json_annotation/json_annotation.dart';

import 'search_result_dto.dt.dart';

part 'search_content_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class SearchContentDTO {
  final List<SearchResultDTO> search;

  SearchContentDTO(this.search);

  factory SearchContentDTO.fromJson(Map<String, dynamic> json) => _$SearchContentDTOFromJson(json);
}
