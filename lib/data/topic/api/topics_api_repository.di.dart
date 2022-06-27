import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topics_from_editor_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topics_from_expert_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsRepository)
class TopicsApiRepository implements TopicsRepository {
  TopicsApiRepository(
    this._topicsApiDataSource,
    this._topicsFromExpertDTOMapper,
    this._topicsFromEditorDTOMapper,
    this._topicDTOMapper,
  );
  final TopicsApiDataSource _topicsApiDataSource;
  final TopicsFromExpertDTOMapper _topicsFromExpertDTOMapper;
  final TopicsFromEditorDTOMapper _topicsFromEditorDTOMapper;
  final TopicDTOMapper _topicDTOMapper;

  @override
  Future<List<TopicPreview>> getTopicPreviewsFromExpert(String expertId, [String? excludedTopicSlug]) async {
    final dto = await _topicsApiDataSource.getTopicsFromExpert(expertId, excludedTopicSlug);
    return _topicsFromExpertDTOMapper(dto);
  }

  @override
  Future<List<TopicPreview>> getTopicPreviewsFromEditor(String editorId, [String? excludedTopicSlug]) async {
    final dto = await _topicsApiDataSource.getTopicsFromEditor(editorId, excludedTopicSlug);
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

  @override
  Future<void> markTopicAsVisited(String slug) => _topicsApiDataSource.markTopicAsVisited(slug);
}
