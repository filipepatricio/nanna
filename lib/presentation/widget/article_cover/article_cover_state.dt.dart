import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_cover_state.dt.freezed.dart';

@Freezed(toJson: false)
class ArticleCoverState with _$ArticleCoverState {
  @Implements<BuildState>()
  factory ArticleCoverState.initializing() = _ArticleCoverStateInitializing;

  @Implements<BuildState>()
  factory ArticleCoverState.idle(
    MediaItemArticle article,
  ) = _ArticleCoverStateIdle;
}
