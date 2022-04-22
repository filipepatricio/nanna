import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageDTOMapper implements Mapper<ImageDTO, Image> {
  @override
  Image call(ImageDTO data) {
    return Image(
      publicId: data.publicId,
      caption: data.caption,
    );
  }
}
