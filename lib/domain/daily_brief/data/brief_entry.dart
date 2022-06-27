import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';

class BriefEntry {
  BriefEntry({
    required this.item,
    required this.style,
  });
  final BriefEntryItem item;
  final BriefEntryStyle style;

  String get id {
    return item.mapOrNull(
          article: (data) => data.article.mapOrNull(article: (data) => data.id) ?? '',
          topicPreview: (data) => data.topicPreview.id,
        ) ??
        '';
  }

  BriefEntryType get type {
    return item.mapOrNull(
          article: (data) => BriefEntryType.article,
          topicPreview: (data) => BriefEntryType.topic,
        ) ??
        BriefEntryType.unknown;
  }
}

enum BriefEntryType {
  article,
  topic,
  unknown,
}
