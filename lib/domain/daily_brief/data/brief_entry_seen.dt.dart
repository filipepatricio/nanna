import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_entry_seen.dt.freezed.dart';

@Freezed(toJson: false)
class BriefEntrySeen with _$BriefEntrySeen {
  const factory BriefEntrySeen.article(String slug) = _Article;

  const factory BriefEntrySeen.topic(String slug) = _Topic;

  factory BriefEntrySeen.fromEntry(BriefEntry entry) {
    return entry.item.map(
      article: (article) => BriefEntrySeen.article(entry.slug),
      topicPreview: (topic) => BriefEntrySeen.topic(entry.slug),
      unknown: (_) => throw Exception('Unknown BriefEntryItem type'),
    );
  }
}
