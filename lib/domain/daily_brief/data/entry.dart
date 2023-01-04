import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

class Entry {
  Entry({
    required this.note,
    required this.item,
    required this.style,
  });
  final String? note;
  final MediaItem item;
  final EntryStyle style;

  Entry copyWith({
    String? note,
    MediaItem? item,
    EntryStyle? style,
  }) {
    return Entry(
      note: note ?? this.note,
      item: item ?? this.item,
      style: style ?? this.style,
    );
  }
}
