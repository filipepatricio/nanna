import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_data_dto.dt.freezed.dart';

@freezed
class BookmarkDataDTO with _$BookmarkDataDTO {
  factory BookmarkDataDTO.topic(TopicPreviewDTO topic) = _BookmarkDataDTOTopic;

  factory BookmarkDataDTO.article(ArticleHeaderDTO article) = _BookmarkDataDTOArticle;

  factory BookmarkDataDTO.unknown(String type) = _BookmarkDataDTOUnknown;

  factory BookmarkDataDTO.fromJson(Map<String, dynamic> json) {
    final typename = json['__typename'] as String?;

    switch (typename) {
      case 'Topic':
        return BookmarkDataDTO.topic(TopicPreviewDTO.fromJson(json));
      case 'Article':
        return BookmarkDataDTO.article(ArticleHeaderDTO.fromJson(json));
      default:
        return BookmarkDataDTO.unknown(typename ?? '');
    }
  }
}
