import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/entry_style_type_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:injectable/injectable.dart';

const _map = {
  EntryStyleType.articleCoverWithBigImage: 'articleCoverWithBigImage',
  EntryStyleType.articleCoverWithoutImage: 'articleCoverWithoutImage',
};

@injectable
class EntryStyleTypeEntityMapper implements BidirectionalMapper<EntryStyleTypeEntity, EntryStyleType> {
  @override
  EntryStyleTypeEntity from(EntryStyleType data) {
    return EntryStyleTypeEntity(name: _map[data]!);
  }

  @override
  EntryStyleType to(EntryStyleTypeEntity data) {
    return _map.entries.firstWhere((e) => e.value == data.name).key;
  }
}
