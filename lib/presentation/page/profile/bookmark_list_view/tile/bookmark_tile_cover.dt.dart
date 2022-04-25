import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_tile_cover.dt.freezed.dart';

@freezed
class BookmarkTileCover with _$BookmarkTileCover {
  factory BookmarkTileCover.standard(Bookmark bookmark) = _BookmarkTileCoverStandard;

  factory BookmarkTileCover.dynamic(
    Bookmark bookmark,
    int indexOfType,
  ) = _BookmarkTileCoverDynamic;
}
