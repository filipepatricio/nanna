import 'package:better_informed_mobile/domain/article/data/article_content.dart';
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
  const factory MediaItemState.idlePremium(MediaItemArticle header, ArticleContent content) =
      _MediaItemStateIdlePremium;

  @Implements<BuildState>()
  const factory MediaItemState.idleFree(MediaItemArticle header) = _MediaItemStateIdleFree;

  @Implements<BuildState>()
  const factory MediaItemState.error(MediaItemArticle article) = _MediaItemStateError;

  @Implements<BuildState>()
  const factory MediaItemState.emptyError() = _MediaItemStateEmptyError;
}