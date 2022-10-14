import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicDTOMapper implements Mapper<TopicDTO, Topic> {
  TopicDTOMapper(
    this._imageDTOMapper,
    this._entryDTOMapper,
    this._summaryCardDTOMapper,
    this._topicPublisherInformationDTOMapper,
    this._topicOwnerDTOMapper,
  );
  final ImageDTOMapper _imageDTOMapper;
  final EntryDTOMapper _entryDTOMapper;
  final SummaryCardDTOMapper _summaryCardDTOMapper;
  final TopicPublisherInformationDTOMapper _topicPublisherInformationDTOMapper;
  final TopicOwnerDTOMapper _topicOwnerDTOMapper;

  @override
  Topic call(TopicDTO data) {
    return Topic(
      id: data.id,
      slug: data.slug,
      title: data.title,
      strippedTitle: data.strippedTitle,
      introduction: data.introduction,
      url: data.url,
      owner: _topicOwnerDTOMapper(data.owner),
      lastUpdatedAt: DateTime.parse(data.lastUpdatedAt).toLocal(),
      publisherInformation: _topicPublisherInformationDTOMapper(data.publisherInformation),
      heroImage: _imageDTOMapper(data.heroImage),
      entries: data.entries.map<Entry>(_entryDTOMapper).toList(),
      topicSummaryList: data.summaryCards.map<TopicSummary>(_summaryCardDTOMapper).toList(),
      visited: data.visited,
    );
  }
}
