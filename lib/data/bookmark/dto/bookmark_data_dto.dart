import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_data_dto.freezed.dart';

@freezed
class BookmarkDataDTO with _$BookmarkDataDTO {
  factory BookmarkDataDTO.topic(TopicDTO topic) = _BookmarkDataDTOTopic;

  factory BookmarkDataDTO.article(ArticleDTO article) = _BookmarkDataDTOArticle;

  factory BookmarkDataDTO.unknown(String type) = _BookmarkDataDTOUnknown;

  factory BookmarkDataDTO.fromJson(Map<String, dynamic> json) {
    final typename = json['__typename'] as String?;

    switch (typename) {
      case 'Topic':
        return BookmarkDataDTO.topic(TopicDTO.fromJson(json));
      case 'Article':
        return BookmarkDataDTO.article(ArticleDTO.fromJson(json));
      default:
        return BookmarkDataDTO.unknown(typename ?? '');
    }
  }
}
