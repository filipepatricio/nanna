import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_state.dt.freezed.dart';

@freezed
class BookmarkState with _$BookmarkState {
  factory BookmarkState.bookmarked(String id) = _BookmarkStateBookmarked;
  factory BookmarkState.notBookmarked() = _BookmarkStateNotBookmarked;
}
