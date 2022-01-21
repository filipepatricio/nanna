import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topics_from_expert_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsRepository)
class TopicsApiRepository implements TopicsRepository {
  final TopicsApiDataSource _topicsApiDataSource;
  final TopicsFromExpertDTOMapper _topicsFromExpertDTOMapper;
  final TopicDTOMapper _topicDTOMapper;

  TopicsApiRepository(
    this._topicsApiDataSource,
    this._topicsFromExpertDTOMapper,
    this._topicDTOMapper,
  );

  @override
  Future<List<Topic>> getTopicsFromExpert(String expertId) async {
    final dto = await _topicsApiDataSource.getTopicsFromExpert(expertId);
    final topicsFromExpert = _topicsFromExpertDTOMapper(dto);

    return topicsFromExpert;
  }

  @override
  Future<Topic> getTopicBySlug(String slug) async {
    final dto = await _topicsApiDataSource.getTopicBySlug(slug);
    return _topicDTOMapper(dto);
  }
}
