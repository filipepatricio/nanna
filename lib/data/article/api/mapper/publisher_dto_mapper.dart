import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:injectable/injectable.dart';

@injectable
class PublisherDTOMapper implements Mapper<PublisherDTO, Publisher> {
  final ImageDTOMapper _imageDTOMapper;

  PublisherDTOMapper(this._imageDTOMapper);

  @override
  Publisher call(PublisherDTO data) {
    return Publisher(
      name: data.name,
      lightLogo: _imageDTOMapper(data.lightLogo),
      darkLogo: _imageDTOMapper(data.darkLogo),
    );
  }
}
