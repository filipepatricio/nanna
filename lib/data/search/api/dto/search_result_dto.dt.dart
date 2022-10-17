import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_dto.dt.freezed.dart';

@Freezed(toJson: false)
class SearchResultDTO with _$SearchResultDTO {
  factory SearchResultDTO.topic(TopicPreviewDTO topicPreview) = _SearchResultDTOTopic;

  factory SearchResultDTO.article(ArticleHeaderDTO article) = _SearchResultDTOArticle;

  factory SearchResultDTO.unknown(String type) = _SearchResultDTOUnknown;

  factory SearchResultDTO.fromJson(Map<String, dynamic> json) {
    final typename = json['__typename'] as String?;

    switch (typename) {
      case 'Topic':
        return SearchResultDTO.topic(TopicPreviewDTO.fromJson(json));
      case 'Article':
        return SearchResultDTO.article(ArticleHeaderDTO.fromJson(json));
      default:
        return SearchResultDTO.unknown(typename ?? '');
    }
  }
}
