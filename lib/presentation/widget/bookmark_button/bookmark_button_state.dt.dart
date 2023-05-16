import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_button_state.dt.freezed.dart';

@Freezed(toJson: false)
class BookmarkButtonState with _$BookmarkButtonState {
  @Implements<BuildState>()
  factory BookmarkButtonState.initializing() = _BookmarkButtonStateInitializing;

  @Implements<BuildState>()
  factory BookmarkButtonState.idle(
    BookmarkTypeData data,
    BookmarkState state,
  ) = _BookmarkButtonStateIdle;

  @Implements<BuildState>()
  factory BookmarkButtonState.switching(
    BookmarkTypeData data,
  ) = _BookmarkButtonStateSwitching;

  @Implements<BuildState>()
  factory BookmarkButtonState.offline(
    BookmarkState state,
  ) = _BookmarkButtonStateOffline;

  @Implements<BuildState>()
  factory BookmarkButtonState.guest() = _BookmarkButtonStateGuest;

  factory BookmarkButtonState.bookmarkAdded(String message) = _BookmarkButtonStateBookmarkAdded;

  factory BookmarkButtonState.bookmarkRemoved(String message) = _BookmarkButtonStateBookmarkedRemoved;
}
