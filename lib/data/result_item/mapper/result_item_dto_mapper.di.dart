import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/result_item/dto/result_item_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/general/result_item.dt.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResultItemDTOMapper implements Mapper<ResultItemDTO, ResultItem> {
  ResultItemDTOMapper(this._topicDTOMapper, this._articleDTOMapper);

  final TopicPreviewDTOMapper _topicDTOMapper;
  final ArticleDTOToMediaItemMapper _articleDTOMapper;

  @override
  ResultItem call(ResultItemDTO data) {
    return data.map(
      topic: (topic) => ResultItem.topic(_topicDTOMapper(topic.topicPreview)),
      article: (article) => ResultItem.article(_articleDTOMapper(article.article)),
      unknown: (unknown) {
        Fimber.e('Encountered unknown search result with type: ${unknown.type}');
        return ResultItem.unknown();
      },
    );
  }
}
