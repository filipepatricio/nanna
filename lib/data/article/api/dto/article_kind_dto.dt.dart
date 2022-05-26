import 'package:json_annotation/json_annotation.dart';

part 'article_kind_dto.dt.g.dart';

@JsonSerializable()
class ArticleKindDTO {
  final String name;

  ArticleKindDTO(
    this.name,
  );

  factory ArticleKindDTO.fromJson(Map<String, dynamic> json) => _$ArticleKindDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleKindDTOToJson(this);
}
