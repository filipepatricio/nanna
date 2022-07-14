import 'package:better_informed_mobile/data/article/api/dto/article_content_type_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_content_dto.dt.g.dart';

@JsonSerializable()
class ArticleContentDTO {
  ArticleContentDTO(this.content, this.markupLanguage);

  factory ArticleContentDTO.fromJson(Map<String, dynamic> json) => _$ArticleContentDTOFromJson(json);
  final String content;
  final ArticleContentTypeDTO markupLanguage;

  Map<String, dynamic> toJson() => _$ArticleContentDTOToJson(this);
}
