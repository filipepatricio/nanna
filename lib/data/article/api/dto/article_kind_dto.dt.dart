import 'package:json_annotation/json_annotation.dart';

part 'article_kind_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ArticleKindDTO {
  ArticleKindDTO(
    this.name,
  );

  factory ArticleKindDTO.fromJson(Map<String, dynamic> json) => _$ArticleKindDTOFromJson(json);
  final String name;
}
