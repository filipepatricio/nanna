import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_page_data.freezed.dart';

@freezed
class ArticlePageData with _$ArticlePageData {
  factory ArticlePageData.singleArticle({
    required ArticleHeader article,
    double? readArticleProgress,
    ArticleNavigationCallback? navigationCallback,
  }) = _ArticlePageDataSingleArticle;

  factory ArticlePageData.multipleArticles({
    required int index,
    required List<ArticleHeader> articleList,
    double? readArticleProgress,
    ArticleNavigationCallback? navigationCallback,
  }) = _ArticlePageDataMultipleArticles;
}
