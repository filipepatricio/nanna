import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:injectable/injectable.dart';

@injectable
class PublisherDTOMapper implements Mapper<PublisherDTO, Publisher> {
  final ImageDTOMapper _imageDTOMapper;

  PublisherDTOMapper(this._imageDTOMapper);

  @override
  Publisher call(PublisherDTO data) {
    final lightLogo = data.lightLogo;
    final darkLogo = data.darkLogo;
    return Publisher(
      name: data.name,
      lightLogo: lightLogo == null ? null : _imageDTOMapper(lightLogo),
      darkLogo: darkLogo == null ? null : _imageDTOMapper(darkLogo),
    );
  }
}
