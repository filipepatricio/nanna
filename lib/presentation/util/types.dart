import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';

typedef OpenInBrowserFunction = Future<void> Function(String);

typedef OnRemoveBookmarkPressed = void Function(Bookmark bookmark);
