import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_list_articles_select_view_state.dt.freezed.dart';

@freezed
class ReadingListArticlesSelectViewState with _$ReadingListArticlesSelectViewState {
  @Implements<BuildState>()
  factory ReadingListArticlesSelectViewState.initializing() = _ReadingListArticlesSelectViewStateInitializing;

  @Implements<BuildState>()
  factory ReadingListArticlesSelectViewState.idle(
    bool canSelectMore,
    List<MediaItemArticle> articles,
    Set<int> selectedIndexes,
    int articlesSelectionLimit,
  ) = _ReadingListArticlesSelectViewStateIdle;

  @Implements<BuildState>()
  factory ReadingListArticlesSelectViewState.generatingShareImage() =
      _ReadingListArticlesSelectViewStateGeneratingShareImage;

  factory ReadingListArticlesSelectViewState.shared() = _ReadingListArticlesSelectViewStateShared;
}
