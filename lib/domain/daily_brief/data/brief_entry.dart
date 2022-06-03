import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';

class BriefEntry {
  final BriefEntryItem item;
  final BriefEntryStyle style;

  BriefEntry({
    required this.item,
    required this.style,
  });
}
