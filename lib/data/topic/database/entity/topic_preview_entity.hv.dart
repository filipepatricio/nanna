import 'package:better_informed_mobile/data/article/database/entity/category_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/curation_info_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_publisher_information_entity.hv.dart';
import 'package:hive/hive.dart';

part 'topic_preview_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.topicPreviewEntity)
class TopicPreviewEntity {
  TopicPreviewEntity({
    required this.id,
    required this.slug,
    required this.title,
    required this.strippedTitle,
    required this.introduction,
    required this.ownersNote,
    required this.url,
    required this.curationInfo,
    required this.lastUpdatedAt,
    required this.publisherInformation,
    required this.heroImage,
    required this.entryCount,
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
  final DateTime lastUpdatedAt;
  @HiveField(9)
  final TopicPublisherInformationEntity publisherInformation;
  @HiveField(10)
  final ImageEntity heroImage;
  @HiveField(11)
  final int entryCount;
  @HiveField(12)
  final bool visited;
  @HiveField(13)
  final CategoryEntity category;
}
