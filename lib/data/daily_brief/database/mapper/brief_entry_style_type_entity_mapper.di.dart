import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_style_type_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:injectable/injectable.dart';

const _map = {
  BriefEntryStyleType.articleCardLarge: 'articleCardLarge',
  BriefEntryStyleType.articleCardMedium: 'articleCardMedium',
  BriefEntryStyleType.topicCard: 'topicCard',
};

@injectable
class BriefEntryStyleTypeEntityMapper implements BidirectionalMapper<BriefEntryStyleTypeEntity, BriefEntryStyleType> {
  @override
  BriefEntryStyleTypeEntity from(BriefEntryStyleType data) {
    return BriefEntryStyleTypeEntity(_map[data]!);
  }

  @override
  BriefEntryStyleType to(BriefEntryStyleTypeEntity data) {
    return _map.entries.firstWhere((e) => e.value == data.name).key;
  }
}
