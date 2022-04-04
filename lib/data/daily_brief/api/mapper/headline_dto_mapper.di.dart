import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:injectable/injectable.dart';

@injectable
class HeadlineDTOMapper implements Mapper<HeadlineDTO, Headline> {
  @override
  Headline call(HeadlineDTO data) {
    return Headline(
      headline: data.headline,
      message: data.message,
      icon: data.icon,
    );
  }
}
