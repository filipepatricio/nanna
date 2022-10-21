import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_publisher_information_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class TopicPublisherInformationDTO {
  TopicPublisherInformationDTO(
    this.highlightedPublishers,
    this.remainingPublishersIndicator,
  );

  factory TopicPublisherInformationDTO.fromJson(Map<String, dynamic> json) =>
      _$TopicPublisherInformationDTOFromJson(json);
  final List<PublisherDTO> highlightedPublishers;
  final String? remainingPublishersIndicator;
}
