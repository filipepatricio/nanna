import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';

class Bookmark {
  Bookmark(this.id, this.data);

  final String id;
  final BookmarkData data;

  Bookmark copyWith({String? id, BookmarkData? data}) {
    return Bookmark(
      id ?? this.id,
      data ?? this.data,
    );
  }
}
