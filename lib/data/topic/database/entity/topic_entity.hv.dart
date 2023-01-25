import 'package:better_informed_mobile/data/article/database/entity/category_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/curation_info_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entry_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_publisher_information_entity.hv.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'topic_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.topicEntity)
class TopicEntity {
  TopicEntity({
    required this.id,
    required this.slug,
    required this.title,
    required this.strippedTitle,
    required this.introduction,
    required this.ownersNote,
    required this.url,
    required this.curationInfo,
    required this.summary,
    required this.lastUpdatedAt,
    required this.publisherInformation,
    required this.heroImage,
    required this.entries,
    required this.visited,
    required this.category,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String strippedTitle;
  @HiveField(4)
  final String introduction;
  @HiveField(5)
  final String? ownersNote;
  @HiveField(6)
  final String url;
  @HiveField(7)
  final CurationInfoEntity curationInfo;
  @HiveField(8)
  final String? summary;
  @HiveField(9)
  final String lastUpdatedAt;
  @HiveField(10)
  final TopicPublisherInformationEntity publisherInformation;
  @HiveField(11)
  final ImageEntity heroImage;
  @HiveField(12)
  final List<TopicEntryEntity> entries;
  @HiveField(13)
  final bool visited;
  @HiveField(14)
  final CategoryEntity category;
}
