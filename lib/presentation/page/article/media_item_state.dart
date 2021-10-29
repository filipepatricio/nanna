import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_state.freezed.dart';

@freezed
class MediaItemState with _$MediaItemState {
  @Implements(BuildState)
  const factory MediaItemState.initializing() = _MediaItemStateInitializing;

  @Implements(BuildState)
  const factory MediaItemState.loading() = _MediaItemStateLoading;

  @Implements(BuildState)
  const factory MediaItemState.idleMultiItems(
    Entry header,
    ArticleContent content,
    bool hasNext,
  ) = MultiMediaItemStateIdle;

  @Implements(BuildState)
  const factory MediaItemState.idleSingleItem(
    Entry header,
    ArticleContent content,
  ) = SingleMediaItemStateIdle;

  const factory MediaItemState.nextPageLoaded(int index) = _MediaItemStateNextPageLoaded;

  @Implements(BuildState)
  const factory MediaItemState.error(Entry entry) = _MediaItemStateError;
}