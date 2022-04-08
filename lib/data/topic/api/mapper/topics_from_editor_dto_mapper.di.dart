import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_editor_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicsFromEditorDTOMapper implements Mapper<TopicsFromEditorDTO, List<Topic>> {
  final TopicDTOMapper _topicDTOMapper;

  TopicsFromEditorDTOMapper(this._topicDTOMapper);

  @override
  List<Topic> call(TopicsFromEditorDTO data) {
    return data.topics.map<Topic>(_topicDTOMapper).toList();
  }
}
