import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_state.dt.freezed.dart';

@freezed
class MediaItemState with _$MediaItemState {
  @Implements<BuildState>()
  const factory MediaItemState.initializing() = _MediaItemStateInitializing;

  @Implements<BuildState>()
  const factory MediaItemState.loading() = _MediaItemStateLoading;

  @Implements<BuildState>()
  const factory MediaItemState.idlePremium(Article article) = _MediaItemStateIdlePremium;

  @Implements<BuildState>()
  const factory MediaItemState.idleFree(MediaItemArticle header) = _MediaItemStateIdleFree;

  @Implements<BuildState>()
  const factory MediaItemState.error(MediaItemArticle article) = _MediaItemStateError;

  @Implements<BuildState>()
  const factory MediaItemState.geoblocked() = _MediaItemStateGeoblocked;

  @Implements<BuildState>()
  const factory MediaItemState.emptyError({MediaItemArticle? article}) = _MediaItemStateEmptyError;
}
