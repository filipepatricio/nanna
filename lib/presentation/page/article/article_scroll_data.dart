import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_scroll_data.freezed.dart';

@freezed
class ArticleScrollData with _$ArticleScrollData {
  factory ArticleScrollData({
    required double contentOffset,
    required double readArticleContentOffset,
    required double articleContentHeight,
    required double articlePageHeight,
  }) = _ArticleScrollData;
}
