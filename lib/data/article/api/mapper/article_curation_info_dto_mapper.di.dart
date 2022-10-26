import 'package:better_informed_mobile/data/article/api/dto/article_curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/data/article_curation_info.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleCurationInfoDTOMapper implements Mapper<ArticleCurationInfoDTO, ArticleCurationInfo> {
  ArticleCurationInfoDTOMapper(this._topicOwnerDTOMapper);

  final CuratorDTOMapper _topicOwnerDTOMapper;

  @override
  ArticleCurationInfo call(ArticleCurationInfoDTO data) {
    return ArticleCurationInfo(
      data.byline,
      _topicOwnerDTOMapper(data.curator),
    );
  }
}
