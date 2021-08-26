import 'package:json_annotation/json_annotation.dart';

part 'article_content_dto.g.dart';

@JsonSerializable()
class ArticleContentDTO {
  final String content;
  final String markupLanguage;

  ArticleContentDTO(this.content, this.markupLanguage);

  factory ArticleContentDTO.fromJson(Map<String, dynamic> json) => _$ArticleContentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleContentDTOToJson(this);
}