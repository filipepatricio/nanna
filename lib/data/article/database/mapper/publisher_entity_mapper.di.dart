import 'package:better_informed_mobile/data/article/database/entity/publisher_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/image_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:injectable/injectable.dart';

@injectable
class PublisherEntityMapper extends BidirectionalMapper<PublisherEntity, Publisher> {
  PublisherEntityMapper(this._imageEntityMapper);

  final ImageEntityMapper _imageEntityMapper;

  @override
  PublisherEntity from(Publisher data) {
    final darkLogo = data.darkLogo;
    final lightLogo = data.lightLogo;

    return PublisherEntity(
      name: data.name,
      darkLogo: darkLogo != null ? _imageEntityMapper.from(darkLogo) : null,
      lightLogo: lightLogo != null ? _imageEntityMapper.from(lightLogo) : null,
    );
  }

  @override
  Publisher to(PublisherEntity data) {
    final darkLogo = data.darkLogo;
    final lightLogo = data.lightLogo;

    return Publisher(
      name: data.name,
      darkLogo: darkLogo != null ? _imageEntityMapper.to(darkLogo) : null,
      lightLogo: lightLogo != null ? _imageEntityMapper.to(lightLogo) : null,
    );
  }
}
