import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';

class ReadingList {
  final String id;
  final List<Entry> entries;

  ReadingList({
    required this.id,
    required this.entries,
  });
}
