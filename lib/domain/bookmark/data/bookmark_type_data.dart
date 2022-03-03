import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_type_data.freezed.dart';

@freezed
class BookmarkTypeData with _$BookmarkTypeData {
  const factory BookmarkTypeData.article(String slug) = _BookmarkTypeDataArticle;

  const factory BookmarkTypeData.topic(String slug) = _BookmarkTypeDataTopic;
}
