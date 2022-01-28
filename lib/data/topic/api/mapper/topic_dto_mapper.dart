import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/reading_list_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicDTOMapper implements Mapper<TopicDTO, Topic> {
  final ImageDTOMapper _imageDTOMapper;
  final ReadingListDTOMapper _readingListDTOMapper;
  final SummaryCardDTOMapper _summaryCardDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final TopicOwnerDTOMapper _topicOwnerDTOMapper;

  TopicDTOMapper(
    this._imageDTOMapper,
    this._readingListDTOMapper,
    this._summaryCardDTOMapper,
    this._publisherDTOMapper,
    this._topicOwnerDTOMapper,
  );

  @override
  Topic call(TopicDTO data) {
    return Topic(
      id: data.id,
      title: data.title,
      strippedTitle: data.strippedTitle,
      introduction: data.introduction,
      owner: _topicOwnerDTOMapper(data.owner),
      lastUpdatedAt: DateTime.parse(data.lastUpdatedAt).toLocal(),
      highlightedPublishers: data.highlightedPublishers.map<Publisher>(_publisherDTOMapper).toList(),
      heroImage: _imageDTOMapper(data.heroImage),
      coverImage: _imageDTOMapper(data.coverImage),
      readingList: _readingListDTOMapper(data.readingList),
      topicSummaryList: data.summaryCards.map<TopicSummary>(_summaryCardDTOMapper).toList(),
    );
  }
}
