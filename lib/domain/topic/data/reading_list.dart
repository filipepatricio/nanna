import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';

class ReadingList {
  final String id;
  final String name;
  final List<Entry> entries;

  ReadingList({
    required this.id,
    required this.name,
    required this.entries,
  });
}
