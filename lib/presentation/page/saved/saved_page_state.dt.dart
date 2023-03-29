import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class SavedPageState with _$SavedPageState {
  @Implements<BuildState>()
  factory SavedPageState.initializing() = _SavedPageStateInitializing;

  @Implements<BuildState>()
  factory SavedPageState.idle(
    BookmarkFilter filter,
    BookmarkSortConfigName sortConfigName,
    bool hasActiveSubscription, [
    @Default(0) int version,
  ]) = _SavedPageStateIdle;

  factory SavedPageState.showTutorialToast(String text) = _SavedPageStateShowTutorialToast;
}
