import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_seen_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntrySeenEntityMapper implements BidirectionalMapper<BriefEntrySeenEntity, BriefEntrySeen> {
  @override
  BriefEntrySeenEntity from(BriefEntrySeen data) {
    return data.map(
      article: (article) => BriefEntrySeenEntity.article(slug: article.slug),
      topic: (topic) => BriefEntrySeenEntity.topic(slug: topic.slug),
    );
  }

  @override
  BriefEntrySeen to(BriefEntrySeenEntity data) {
    return data.map(
      article: (slug) => BriefEntrySeen.article(slug),
      topic: (slug) => BriefEntrySeen.topic(slug),
    );
  }
}
