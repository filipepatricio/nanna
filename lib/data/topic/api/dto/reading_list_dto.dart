import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reading_list_dto.g.dart';

@JsonSerializable()
class ReadingListDTO {
  final String id;
  final List<ArticleDTO> articles;

  ReadingListDTO(this.id, this.articles);

  factory ReadingListDTO.fromJson(Map<String, dynamic> json) => _$ReadingListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingListDTOToJson(this);
}