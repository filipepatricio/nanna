import 'package:better_informed_mobile/data/article/api/mapper/article_header_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_dto.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadingListDTOMapper implements Mapper<ReadingListDTO, ReadingList> {
  final ArticleHeaderDTOMapper _articleHeaderDTOMapper;

  ReadingListDTOMapper(this._articleHeaderDTOMapper);

  @override
  ReadingList call(ReadingListDTO data) {
    return ReadingList(
      id: data.id,
      articles: data.articles.map<ArticleHeader>(_articleHeaderDTOMapper).toList(),
    );
  }
}
