import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_type_data.dt.freezed.dart';

@Freezed(toJson: false)
class BookmarkTypeData with _$BookmarkTypeData {
  const factory BookmarkTypeData.article(
    String slug,
    String articleId, [
    String? topicId,
    String? briefId,
  ]) = _BookmarkTypeDataArticle;

  const factory BookmarkTypeData.topic(
    String slug,
    String topicId, [
    String? briefId,
  ]) = _BookmarkTypeDataTopic;
}
