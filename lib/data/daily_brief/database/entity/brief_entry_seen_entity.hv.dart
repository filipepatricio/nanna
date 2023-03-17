import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_entry_seen_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefEntrySeenEntity)
class BriefEntrySeenEntity {
  BriefEntrySeenEntity({
    required this.slug,
    required this.type,
  });

  BriefEntrySeenEntity.article({
    required String slug,
  }) : this(
          slug: slug,
          type: 'article',
        );

  BriefEntrySeenEntity.topic({
    required String slug,
  }) : this(
          slug: slug,
          type: 'topic',
        );

  @HiveField(0)
  final String slug;
  @HiveField(1)
  final String type;

  T map<T>({
    required T Function(String slug) article,
    required T Function(String slug) topic,
  }) {
    switch (type) {
      case 'article':
        return article(slug);
      case 'topic':
        return topic(slug);
      default:
        throw Exception('Unknown type: $type');
    }
  }
}
