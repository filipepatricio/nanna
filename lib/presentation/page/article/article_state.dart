import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_state.freezed.dart';

@freezed
class ArticleState with _$ArticleState {
  @Implements(BuildState)
  const factory ArticleState.initializing() = _ArticleStateInitializing;

  @Implements(BuildState)
  const factory ArticleState.loading() = _ArticleStateLoading;

  @Implements(BuildState)
  const factory ArticleState.idleMultiArticles(
    Entry header,
    ArticleContent content,
    bool hasNext,
  ) = ArticleStateIdleMultiArticles;

  @Implements(BuildState)
  const factory ArticleState.idleSingleArticle(
    Entry header,
    ArticleContent content,
  ) = ArticleStateIdleSingleArticle;

  const factory ArticleState.nextPageLoaded(int index) = _ArticleStateNextPageLoaded;

  @Implements(BuildState)
  const factory ArticleState.error(Entry entry) = _ArticleStateError;
}
