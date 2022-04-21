import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/headline_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentBriefDTOMapper implements Mapper<CurrentBriefDTO, CurrentBrief> {
  CurrentBriefDTOMapper(
    this._headlineDTOMapper,
    this._topicPreviewDTOMapper,
  );

  final HeadlineDTOMapper _headlineDTOMapper;
  final TopicPreviewDTOMapper _topicPreviewDTOMapper;

  @override
  CurrentBrief call(CurrentBriefDTO data) {
    return CurrentBrief(
      id: data.id,
      greeting: _headlineDTOMapper(data.greeting),
      goodbye: _headlineDTOMapper(data.goodbye),
      topics: data.topics.map<TopicPreview>(_topicPreviewDTOMapper).toList(),
      numberOfTopics: data.numberOfTopics,
    );
  }
}
