import 'package:json_annotation/json_annotation.dart';

enum ArticleTypeDTO {
  @JsonValue('FREE')
  free,
  @JsonValue('PREMIUM')
  premium,
}
