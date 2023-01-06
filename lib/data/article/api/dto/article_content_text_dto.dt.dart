import 'package:better_informed_mobile/data/article/api/dto/article_content_type_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_content_text_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ArticleContentTextDTO {
  ArticleContentTextDTO(this.content, this.markupLanguage);

  factory ArticleContentTextDTO.fromJson(Map<String, dynamic> json) => _$ArticleContentTextDTOFromJson(json);

  final String content;
  final ArticleContentTypeDTO markupLanguage;
}
