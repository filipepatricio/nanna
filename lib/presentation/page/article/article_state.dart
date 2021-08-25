import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_state.freezed.dart';

@freezed
class ArticleState with _$ArticleState {
  @Implements(BuildState)
  const factory ArticleState.initializing() = _ArticleStateInitializing;

  @Implements(BuildState)
  const factory ArticleState.loading(ArticleHeader header) = _ArticleStateLoading;

  @Implements(BuildState)
  const factory ArticleState.idle(ArticleHeader header, ArticleContent content) = ArticleStateidle;
}
