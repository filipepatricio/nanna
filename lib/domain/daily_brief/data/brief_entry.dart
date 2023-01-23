import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/exception/invalid_property_exception.dart';

class BriefEntry {
  const BriefEntry({
    required this.item,
    required this.style,
    required this.isNew,
  });

  final BriefEntryItem item;
  final BriefEntryStyle style;
  final bool isNew;

  String get id => item.maybeMap(
        article: (data) => data.article.maybeMap(
          article: (data) => data.id,
          orElse: () {
            throw InvalidPropertyException();
          },
        ),
        topicPreview: (data) => data.topicPreview.id,
        orElse: () {
          throw InvalidPropertyException();
        },
      );

  String get slug => item.maybeMap(
        article: (data) => data.article.maybeMap(
          article: (data) => data.slug,
          orElse: () {
            throw InvalidPropertyException();
          },
        ),
        topicPreview: (data) => data.topicPreview.slug,
        orElse: () {
          throw InvalidPropertyException();
        },
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
    bool? isNew,
  }) {
    return BriefEntry(
      item: item ?? this.item,
      style: style ?? this.style,
      isNew: isNew ?? this.isNew,
    );
  }
}

enum BriefEntryType {
  article,
  topic,
  unknown,
}
