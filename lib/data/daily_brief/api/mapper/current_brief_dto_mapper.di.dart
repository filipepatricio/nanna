import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/headline_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentBriefDTOMapper implements Mapper<CurrentBriefDTO, CurrentBrief> {
  CurrentBriefDTOMapper(
    this._headlineDTOMapper,
    this._topicDTOMapper,
  );

  final HeadlineDTOMapper _headlineDTOMapper;
  final TopicDTOMapper _topicDTOMapper;

  @override
  CurrentBrief call(CurrentBriefDTO data) {
    return CurrentBrief(
      id: data.id,
      greeting: _headlineDTOMapper(data.greeting),
      goodbye: _headlineDTOMapper(data.goodbye),
      topics: data.topics.map<Topic>(_topicDTOMapper).toList(),
      numberOfTopics: data.numberOfTopics,
    );
  }
}
