import 'package:better_informed_mobile/data/article/api/dto/article_content_text_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_content_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ArticleContentDTO {
  ArticleContentDTO(
    this.text,
    this.credits,
  );

  factory ArticleContentDTO.fromJson(Map<String, dynamic> json) => _$ArticleContentDTOFromJson(json);

  final ArticleContentTextDTO text;
  final String credits;
}
