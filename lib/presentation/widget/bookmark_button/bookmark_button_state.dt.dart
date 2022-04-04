import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_button_state.dt.freezed.dart';

@freezed
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

  factory BookmarkButtonState.bookmarkAdded() = _BookmarkButtonStateBookmarkAdded;

  factory BookmarkButtonState.bookmarkRemoved() = _BookmarkButtonStateBookmarkedRemoved;
}
