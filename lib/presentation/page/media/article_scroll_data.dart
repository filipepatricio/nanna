import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_scroll_data.freezed.dart';

@freezed
class MediaItemScrollData with _$MediaItemScrollData {
  factory MediaItemScrollData({
    required double contentOffset,
    required double readArticleContentOffset,
    required double contentHeight,
    required double pageHeight,
  }) = _MediaItemScrollData;

  factory MediaItemScrollData.initial() => MediaItemScrollData(
        contentOffset: 0,
        pageHeight: 0,
        contentHeight: 0,
        readArticleContentOffset: 0,
      );
}
