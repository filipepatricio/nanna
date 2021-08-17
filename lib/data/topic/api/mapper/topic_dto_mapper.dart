import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicDTOMapper implements Mapper<TopicDTO, Topic> {
  @override
  Topic call(TopicDTO data) {
    return Topic(
      id: data.id,
      title: data.title,
      introduction: data.introduction,
      summary: data.summary,
    );
  }
}
