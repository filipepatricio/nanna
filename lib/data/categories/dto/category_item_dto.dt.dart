import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_item_dto.dt.freezed.dart';

@Freezed(toJson: false)
class CategoryItemDTO with _$CategoryItemDTO {
  factory CategoryItemDTO.topic(TopicPreviewDTO topicPreview) = _CategoryItemDTOTopic;

  factory CategoryItemDTO.article(ArticleHeaderDTO article) = _CategoryItemDTOArticle;

  factory CategoryItemDTO.unknown(String type) = _CategoryItemDTOUnknown;

  factory CategoryItemDTO.fromJson(Map<String, dynamic> json) {
    final typename = json['__typename'] as String?;

    switch (typename) {
      case 'Topic':
        return CategoryItemDTO.topic(TopicPreviewDTO.fromJson(json));
      case 'Article':
        return CategoryItemDTO.article(ArticleHeaderDTO.fromJson(json));
      default:
        return CategoryItemDTO.unknown(typename ?? '');
    }
  }
}
