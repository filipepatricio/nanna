import 'package:better_informed_mobile/data/article/database/mapper/publisher_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_publisher_information_entity.hv.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicPublisherInformationEntityMapper
    implements BidirectionalMapper<TopicPublisherInformationEntity, TopicPublisherInformation> {
  TopicPublisherInformationEntityMapper(this._publisherEntityMapper);

  final PublisherEntityMapper _publisherEntityMapper;

  @override
  TopicPublisherInformationEntity from(TopicPublisherInformation data) {
    return TopicPublisherInformationEntity(
      highlightedPublishers: data.highlightedPublishers.map(_publisherEntityMapper.from).toList(),
      remainingPublishersIndicator: data.remainingPublishersIndicator,
    );
  }

  @override
  TopicPublisherInformation to(TopicPublisherInformationEntity data) {
    return TopicPublisherInformation(
      highlightedPublishers: data.highlightedPublishers.map(_publisherEntityMapper.to).toList(),
      remainingPublishersIndicator: data.remainingPublishersIndicator,
    );
  }
}
