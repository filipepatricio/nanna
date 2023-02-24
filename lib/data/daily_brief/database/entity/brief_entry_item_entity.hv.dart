import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/media_item_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_preview_entity.hv.dart';
import 'package:hive/hive.dart';

part 'brief_entry_item_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefEntryItemEntity)
class BriefEntryItemEntity {
  const BriefEntryItemEntity({
    this.article,
    this.topic,
    this.unknown,
  });

  BriefEntryItemEntity.article(BriefEntryItemArticleEntity article)
      : this(
          article: article,
          topic: null,
          unknown: null,
        );

  BriefEntryItemEntity.topic(BriefEntryItemTopicEntity topic)
      : this(
          article: null,
          topic: topic,
          unknown: null,
        );

  const BriefEntryItemEntity.unknown()
      : this(
          article: null,
          topic: null,
          unknown: const BriefEntryItemUnknownEntity(),
        );

  @HiveField(0)
  final BriefEntryItemArticleEntity? article;
  @HiveField(1)
  final BriefEntryItemTopicEntity? topic;
  @HiveField(2)
  final BriefEntryItemUnknownEntity? unknown;

  T map<T>({
    required T Function(BriefEntryItemArticleEntity article) article,
    required T Function(BriefEntryItemTopicEntity topic) topic,
    required T Function(BriefEntryItemUnknownEntity unknown) unknown,
  }) {
    if (this.article != null) {
      return article(this.article!);
    } else if (this.topic != null) {
      return topic(this.topic!);
    } else if (this.unknown != null) {
      return unknown(this.unknown!);
    } else {
      throw Exception('Unknown type');
    }
  }
}

@HiveType(typeId: HiveTypes.briefEntryItemArticleEntity)
class BriefEntryItemArticleEntity {
  BriefEntryItemArticleEntity(this.article);

  @HiveField(0)
  final MediaItemEntity article;
}

@HiveType(typeId: HiveTypes.briefEntryItemTopicEntity)
class BriefEntryItemTopicEntity {
  BriefEntryItemTopicEntity(this.topic);

  @HiveField(0)
  final TopicPreviewEntity topic;
}

@HiveType(typeId: HiveTypes.briefEntryItemUnknownEntity)
class BriefEntryItemUnknownEntity {
  const BriefEntryItemUnknownEntity();
}
