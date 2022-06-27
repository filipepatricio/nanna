import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_editor_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicsFromEditorDTOMapper implements Mapper<TopicsFromEditorDTO, List<TopicPreview>> {
  TopicsFromEditorDTOMapper(this._topicPreviewDTOMapper);
  final TopicPreviewDTOMapper _topicPreviewDTOMapper;

  @override
  List<TopicPreview> call(TopicsFromEditorDTO data) {
    return data.topics.map<TopicPreview>(_topicPreviewDTOMapper).toList();
  }
}
