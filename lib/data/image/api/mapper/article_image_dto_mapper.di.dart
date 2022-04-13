import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleImageDTOMapper implements Mapper<ArticleImageDTO, ArticleImage> {
  @override
  ArticleImage call(ArticleImageDTO data) {
    return data.map(
      cloudinary: (data) => ArticleImage.cloudinary(CloudinaryImage(publicId: data.publicId, caption: data.caption)),
      remote: (data) => ArticleImage.remote(url: data.url),
      unknown: (_) => const ArticleImage.unknown(),
    );
  }
}
