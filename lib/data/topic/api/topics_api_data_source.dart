import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dart';

abstract class TopicsApiDataSource {
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId);
}
