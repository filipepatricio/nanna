import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_page_data.freezed.dart';

@freezed
class ArticlePageData with _$ArticlePageData {
  factory ArticlePageData.singleArticle({
    required Entry entry,
    double? readArticleProgress,
    ArticleNavigationCallback? navigationCallback,
  }) = _ArticlePageDataSingleArticle;

  factory ArticlePageData.multipleArticles({
    required int index,
    required List<Entry> entryList,
    double? readArticleProgress,
    ArticleNavigationCallback? navigationCallback,
  }) = _ArticlePageDataMultipleArticles;
}
