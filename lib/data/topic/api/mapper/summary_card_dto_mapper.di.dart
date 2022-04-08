import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/summary_card_dto.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class SummaryCardDTOMapper implements Mapper<SummaryCardDTO, TopicSummary> {
  @override
  TopicSummary call(SummaryCardDTO data) {
    return TopicSummary(
      content: data.text,
    );
  }
}
