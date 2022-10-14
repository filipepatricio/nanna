import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_publisher_information_dto.dt.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicPublisherInformationDTOMapper implements Mapper<TopicPublisherInformationDTO, TopicPublisherInformation> {
  TopicPublisherInformationDTOMapper(this._publisherDTOMapper);
  final PublisherDTOMapper _publisherDTOMapper;

  @override
  TopicPublisherInformation call(TopicPublisherInformationDTO data) {
    return TopicPublisherInformation(
      highlightedPublishers: data.highlightedPublishers.map<Publisher>(_publisherDTOMapper).toList(),
      remainingPublishersIndicator: data.remainingPublishersIndicator,
    );
  }
}
