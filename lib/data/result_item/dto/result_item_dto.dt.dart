import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_item_dto.dt.freezed.dart';

@freezed
class ResultItemDTO with _$ResultItemDTO {
  factory ResultItemDTO.topic(TopicPreviewDTO topicPreview) = _ResultItemDTOTopic;

  factory ResultItemDTO.article(ArticleHeaderDTO article) = _ResultItemDTOArticle;

  factory ResultItemDTO.unknown(String type) = _ResultItemDTOUnknown;

  factory ResultItemDTO.fromJson(Map<String, dynamic> json) {
    final typename = json['__typename'] as String?;

    switch (typename) {
      case 'Topic':
        return ResultItemDTO.topic(TopicPreviewDTO.fromJson(json));
      case 'Article':
        return ResultItemDTO.article(ArticleHeaderDTO.fromJson(json));
      default:
        return ResultItemDTO.unknown(typename ?? '');
    }
  }
}
