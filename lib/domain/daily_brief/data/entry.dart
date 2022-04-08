import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

class Entry {
  final String? note;
  final MediaItem item;
  final EntryStyle style;

  Entry({
    required this.note,
    required this.item,
    required this.style,
  });
}
