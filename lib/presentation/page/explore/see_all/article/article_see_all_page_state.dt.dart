import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_with_background.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_see_all_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class ArticleSeeAllPageState with _$ArticleSeeAllPageState {
  @Implements<BuildState>()
  factory ArticleSeeAllPageState.loading() = _ArticleSeeAllPageStateLoading;

  @Implements<BuildState>()
  factory ArticleSeeAllPageState.withPagination(List<ArticleWithBackground> articles) =
      _ArticleSeeAllPageStateWithPagination;

  @Implements<BuildState>()
  factory ArticleSeeAllPageState.loadingMore(List<ArticleWithBackground> articles) = _ArticleSeeAllPageStateLoadingMore;

  @Implements<BuildState>()
  factory ArticleSeeAllPageState.allLoaded(List<ArticleWithBackground> articles) = _ArticleSeeAllPageStateAllLoaded;
}
