import 'package:better_informed_mobile/data/daily_brief/api/mapper/category_dto_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicDTOMapper implements Mapper<TopicDTO, Topic> {
  final CategoryDTOMapper _categoryDTOMapper;
  final ImageDTOMapper _imageDTOMapper;

  TopicDTOMapper(
    this._categoryDTOMapper,
    this._imageDTOMapper,
  );

  @override
  Topic call(TopicDTO data) {
    return Topic(
      id: data.id,
      title: data.title,
      introduction: data.introduction,
      summary: data.summary,
      category: _categoryDTOMapper(data.category),
      image: _imageDTOMapper(data.image),
    );
  }
}
