import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_articles_select_view_state.dt.freezed.dart';

@Freezed(toJson: false)
class TopicArticlesSelectViewState with _$TopicArticlesSelectViewState {
  @Implements<BuildState>()
  factory TopicArticlesSelectViewState.initializing() = _TopicArticlesSelectViewStateInitializing;

  @Implements<BuildState>()
  factory TopicArticlesSelectViewState.idle(
    bool canSelectMore,
    List<MediaItemArticle> articles,
    Set<int> selectedIndexes,
    int articlesSelectionLimit,
  ) = _TopicArticlesSelectViewStateIdle;

  @Implements<BuildState>()
  factory TopicArticlesSelectViewState.generatingShareImage() = _TopicArticlesSelectViewStateGeneratingShareImage;

  factory TopicArticlesSelectViewState.shared() = _TopicArticlesSelectViewStateShared;
}
