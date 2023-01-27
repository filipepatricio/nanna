import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageEntityMapper extends BidirectionalMapper<ImageEntity, Image> {
  @override
  ImageEntity from(Image data) {
    return ImageEntity(
      publicId: data.publicId,
      caption: data.caption,
    );
  }

  @override
  Image to(ImageEntity data) {
    return Image(
      publicId: data.publicId,
      caption: data.caption,
    );
  }
}
