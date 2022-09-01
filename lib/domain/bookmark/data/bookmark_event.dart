import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';

class BookmarkEvent {
  BookmarkEvent({
    required this.data,
    required this.state,
  });

  final BookmarkTypeData data;
  final BookmarkState state;
}
