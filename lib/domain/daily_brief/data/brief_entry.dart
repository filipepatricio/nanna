import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';

class BriefEntry {
  const BriefEntry({
    required this.item,
    required this.style,
  });

  final BriefEntryItem item;
  final BriefEntryStyle style;

  String get id => item.maybeMap(
        article: (data) => data.article.maybeMap(article: (data) => data.id, orElse: () => ''),
        topicPreview: (data) => data.topicPreview.id,
        orElse: () => '',
      );

  BriefEntryType get type => item.maybeMap(
        article: (data) => BriefEntryType.article,
        topicPreview: (data) => BriefEntryType.topic,
        orElse: () => BriefEntryType.unknown,
      );

  bool get isTopic => type == BriefEntryType.topic;

  BriefEntry copyWith({
    BriefEntryItem? item,
    BriefEntryStyle? style,
  }) {
    return BriefEntry(
      item: item ?? this.item,
      style: style ?? this.style,
    );
  }
}

enum BriefEntryType {
  article,
  topic,
  unknown,
}
