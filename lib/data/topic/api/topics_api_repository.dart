import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topics_from_editor_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topics_from_expert_dto_mapper.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsRepository)
class TopicsApiRepository implements TopicsRepository {
  final TopicsApiDataSource _topicsApiDataSource;
  final TopicsFromExpertDTOMapper _topicsFromExpertDTOMapper;
  final TopicsFromEditorDTOMapper _topicsFromEditorDTOMapper;
  final TopicDTOMapper _topicDTOMapper;

  TopicsApiRepository(
    this._topicsApiDataSource,
    this._topicsFromExpertDTOMapper,
    this._topicsFromEditorDTOMapper,
    this._topicDTOMapper,
  );

  @override
  Future<List<Topic>> getTopicsFromExpert(String expertId) async {
    final dto = await _topicsApiDataSource.getTopicsFromExpert(expertId);
    return _topicsFromExpertDTOMapper(dto);
  }

  @override
  Future<List<Topic>> getTopicsFromEditor(String editorId) async {
    final dto = await _topicsApiDataSource.getTopicsFromEditor(editorId);
    return _topicsFromEditorDTOMapper(dto);
  }

  @override
  Future<Topic> getTopicBySlug(String slug) async {
    final dto = await _topicsApiDataSource.getTopicBySlug(slug);
    return _topicDTOMapper(dto);
  }

  @override
  Future<String> tradeTopicIdForSlug(String slug) async {
    return _topicsApiDataSource.getTopicId(slug);
  }
}
