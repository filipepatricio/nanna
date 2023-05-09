import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_list_view_state.dt.freezed.dart';

@Freezed(toJson: false)
class BookmarkListViewState with _$BookmarkListViewState {
  @Implements<BuildState>()
  factory BookmarkListViewState.initial() = _BookmarkListViewStateInitial;

  @Implements<BuildState>()
  factory BookmarkListViewState.error() = _BookmarkListViewStateError;

  @Implements<BuildState>()
  factory BookmarkListViewState.loading(
    BookmarkFilter filter,
  ) = _BookmarkListViewStateLoading;

  @Implements<BuildState>()
  factory BookmarkListViewState.empty(
    BookmarkFilter filter,
  ) = _BookmarkListViewStateEmpty;

  @Implements<BuildState>()
  factory BookmarkListViewState.guest(
    BookmarkFilter filter,
  ) = _BookmarkListViewStateGuest;

  @Implements<BuildState>()
  factory BookmarkListViewState.idle(
    BookmarkFilter filter,
    List<Bookmark> bookmarks,
  ) = _BookmarkListViewStateIdle;

  @Implements<BuildState>()
  factory BookmarkListViewState.loadMore(
    BookmarkFilter filter,
    List<Bookmark> bookmarks,
  ) = _BookmarkListViewStateLoadMore;

  @Implements<BuildState>()
  factory BookmarkListViewState.allLoaded(
    BookmarkFilter filter,
    List<Bookmark> bookmarks,
  ) = _BookmarkListViewStateAllLoaded;

  factory BookmarkListViewState.bookmarkRemoved(
    Bookmark bookmark,
    int index,
  ) = _BookmarkListViewStateBookmarkRemoved;
}
