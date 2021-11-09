import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_see_all_page_state.freezed.dart';

@freezed
class ArticleSeeAllPageState with _$ArticleSeeAllPageState {
  @Implements(BuildState)
  factory ArticleSeeAllPageState.loading() = _ArticleSeeAllPageStateLoading;

  @Implements(BuildState)
  factory ArticleSeeAllPageState.withPagination(List<MediaItemArticle> articles) =
      _ArticleSeeAllPageStateWithPagination;

  @Implements(BuildState)
  factory ArticleSeeAllPageState.loadingMore(List<MediaItemArticle> articles) = _ArticleSeeAllPageStateLoadingMore;

  @Implements(BuildState)
  factory ArticleSeeAllPageState.allLoaded(List<MediaItemArticle> articles) = _ArticleSeeAllPageStateAllLoaded;
}
