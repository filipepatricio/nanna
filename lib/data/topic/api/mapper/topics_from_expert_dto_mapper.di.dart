import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicsFromExpertDTOMapper implements Mapper<TopicsFromExpertDTO, List<TopicPreview>> {
  final TopicPreviewDTOMapper _topicPreviewDTOMapper;

  TopicsFromExpertDTOMapper(this._topicPreviewDTOMapper);

  @override
  List<TopicPreview> call(TopicsFromExpertDTO data) {
    return data.topics.map<TopicPreview>(_topicPreviewDTOMapper).toList();
  }
}
