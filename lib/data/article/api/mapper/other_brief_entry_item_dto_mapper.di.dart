import 'package:better_informed_mobile/data/article/api/dto/other_brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_progress_state_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/other_brief_entry_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class OtherBriefEntryItemDTOMapper implements Mapper<OtherBriefEntryItemDTO, OtherBriefEntryItem> {
  OtherBriefEntryItemDTOMapper(this._articleProgressStateDTOMapper);

  final ArticleProgressStateDTOMapper _articleProgressStateDTOMapper;

  @override
  OtherBriefEntryItem call(OtherBriefEntryItemDTO data) {
    return data.map(
      article: (data) {
        return OtherBriefEntryItem.article(
          id: data.id,
          slug: data.slug,
          progressState: _articleProgressStateDTOMapper(data.progressState),
        );
      },
      topicPreview: (data) {
        return OtherBriefEntryItem.topicPreview(
          id: data.id,
          slug: data.slug,
          visited: data.visited,
        );
      },
      unknown: (_) => const OtherBriefEntryItem.unknown(),
    );
  }
}
