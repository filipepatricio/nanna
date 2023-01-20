import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/entry_style_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/media_item_entity.hv.dart';
import 'package:hive/hive.dart';

part 'topic_entry_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.topicEntryEntity)
class TopicEntryEntity {
  TopicEntryEntity({
    required this.note,
    required this.item,
    required this.style,
  });

  @HiveField(0)
  final String? note;
  @HiveField(1)
  final MediaItemEntity item;
  @HiveField(2)
  final EntryStyleEntity style;
}
