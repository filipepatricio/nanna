import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_time_read_label_state.dt.freezed.dart';

@Freezed(toJson: false)
class ArticleTimeReadLabelState with _$ArticleTimeReadLabelState {
  @Implements<BuildState>()
  factory ArticleTimeReadLabelState.initializing() = _ArticleTimeReadLabelStateInitializing;

  @Implements<BuildState>()
  factory ArticleTimeReadLabelState.idle(
    ArticleProgressState progressState,
    int? timeToRead,
  ) = _ArticleTimeReadLabelStateIdle;
}
