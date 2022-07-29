import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_article_view_state.dt.freezed.dart';

@freezed
class FreeArticleViewState with _$FreeArticleViewState {
  @Implements<BuildState>()
  const factory FreeArticleViewState.idle() = _FreeArticleViewStateIDle;
}
