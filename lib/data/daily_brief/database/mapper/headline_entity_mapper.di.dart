import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/headline_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:injectable/injectable.dart';

@injectable
class HeadlineEntityMapper implements BidirectionalMapper<HeadlineEntity, Headline> {
  @override
  HeadlineEntity from(Headline data) {
    return HeadlineEntity(
      headline: data.headline,
      message: data.message,
      icon: data.icon,
    );
  }

  @override
  Headline to(HeadlineEntity data) {
    return Headline(
      headline: data.headline,
      message: data.message,
      icon: data.icon,
    );
  }
}
