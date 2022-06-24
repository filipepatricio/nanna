import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/dto/category_item_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryItemDTOMapper implements Mapper<CategoryItemDTO, CategoryItem> {
  CategoryItemDTOMapper(this._topicDTOMapper, this._articleDTOMapper);

  final TopicPreviewDTOMapper _topicDTOMapper;
  final ArticleDTOToMediaItemMapper _articleDTOMapper;

  @override
  CategoryItem call(CategoryItemDTO data) {
    return data.map(
      topic: (topic) => CategoryItem.topic(_topicDTOMapper(topic.topicPreview)),
      article: (article) => CategoryItem.article(_articleDTOMapper(article.article)),
      unknown: (unknown) {
        Fimber.e('Encountered unknown category item with type: ${unknown.type}');
        return CategoryItem.unknown();
      },
    );
  }
}
