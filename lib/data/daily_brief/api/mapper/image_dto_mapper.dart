import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageDTOMapper implements Mapper<ImageDTO, Image> {
  @override
  Image call(ImageDTO data) {
    return Image(
      publicId: data.publicId,
    );
  }
}
