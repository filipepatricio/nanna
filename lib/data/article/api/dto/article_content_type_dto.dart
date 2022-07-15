import 'package:json_annotation/json_annotation.dart';

enum ArticleContentTypeDTO {
  @JsonValue('HTML')
  html,
  @JsonValue('MARKDOWN')
  markdown,
}
