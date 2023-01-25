import 'package:better_informed_mobile/data/article/database/entity/article_image_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/image_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleImageEntityMapper extends BidirectionalMapper<ArticleImageEntity, ArticleImage> {
  ArticleImageEntityMapper(this._imageEntityMapper);

  final ImageEntityMapper _imageEntityMapper;

  @override
  ArticleImageEntity from(ArticleImage data) {
    return data.map(
      cloudinary: (image) {
        return ArticleImageEntity.cloudinary(
          ArticleCloudinaryImageEntity(
            image: _imageEntityMapper.from(image.cloudinaryImage),
          ),
        );
      },
      remote: (image) {
        return ArticleImageEntity.remote(
          ArticleRemoteImageEntity(
            url: image.url,
          ),
        );
      },
      unknown: (image) {
        return ArticleImageEntity.unknown();
      },
    );
  }

  @override
  ArticleImage to(ArticleImageEntity data) {
    return data.map(
      cloudinary: (image) {
        return ArticleImage.cloudinary(
          _imageEntityMapper.to(image.image),
        );
      },
      remote: (image) {
        return ArticleImage.remote(
          url: image.url,
        );
      },
      unknown: (image) {
        return const ArticleImage.unknown();
      },
    );
  }
}
