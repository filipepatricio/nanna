import 'package:better_informed_mobile/data/article/database/entity/publisher_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'topic_publisher_information_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.topicPublisherInformationEntity)
class TopicPublisherInformationEntity {
  TopicPublisherInformationEntity({
    required this.highlightedPublishers,
    required this.remainingPublishersIndicator,
  });

  @HiveField(0)
  final List<PublisherEntity> highlightedPublishers;
  @HiveField(1)
  final String? remainingPublishersIndicator;
}
