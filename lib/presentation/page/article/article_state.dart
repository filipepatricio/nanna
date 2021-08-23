import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_state.freezed.dart';

@freezed
class ArticleState with _$ArticleState {
  @Implements(BuildState)
  const factory ArticleState.idle() = ArticleStateidle;
}
