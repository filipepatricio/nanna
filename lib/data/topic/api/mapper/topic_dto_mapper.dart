import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/reading_list_dto_mapper.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicDTOMapper implements Mapper<TopicDTO, Topic> {
  final ImageDTOMapper _imageDTOMapper;
  final ReadingListDTOMapper _readingListDTOMapper;

  TopicDTOMapper(
    this._imageDTOMapper,
    this._readingListDTOMapper,
  );

  @override
  Topic call(TopicDTO data) {
    return Topic(
      id: data.id,
      title: data.title,
      introduction: data.introduction,
      summary: data.summary
          .trim()
          .split('*')
          .where((element) => element.isNotEmpty)
          .map((content) => TopicSummary(content: '* ' + content.trim()))
          .toList(),
      heroImage: _imageDTOMapper(data.heroImage),
      coverImage: _imageDTOMapper(data.coverImage),
      readingList: _readingListDTOMapper(data.readingList),
    );
  }
}
