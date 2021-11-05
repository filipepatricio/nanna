import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_content_state.freezed.dart';

@freezed
class ArticleContentState with _$ArticleContentState {
  @Implements(BuildState)
  factory ArticleContentState.loading() = _ArticleContentStateLoading;

  @Implements(BuildState)
  factory ArticleContentState.idle() = _ArticleContentStateIdle;
}
