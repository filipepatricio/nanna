import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_category_dto.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_category.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicCategoryDTOMapper implements Mapper<TopicCategoryDTO?, TopicCategory?> {
  @override
  TopicCategory? call(TopicCategoryDTO? data) {
    if (data == null) return null;
    return TopicCategory(name: data.name);
  }
}
