import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_content.dt.freezed.dart';

@freezed
class ArticleContent with _$ArticleContent {
  factory ArticleContent({
    required ArticleContentType type,
    required String content,
  }) = _ArticleContent;
}
