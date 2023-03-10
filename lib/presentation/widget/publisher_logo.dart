import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart' as informed;
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum PublisherLogoSizeType { small, medium }

class PublisherLogo extends HookWidget {
  const PublisherLogo._({
    required this.publisher,
    required this.image,
    required this.sizeType,
    Key? key,
  }) : super(key: key);

  factory PublisherLogo.dark({
    required Publisher publisher,
    PublisherLogoSizeType sizeType = PublisherLogoSizeType.small,
    Key? key,
  }) =>
      PublisherLogo._(
        publisher: publisher,
        image: kIsTest ? informed.Image(publicId: AppRasterGraphics.testPublisherLogoDark) : publisher.darkLogo,
        sizeType: sizeType,
        key: key,
      );

  factory PublisherLogo.light({
    required Publisher publisher,
    PublisherLogoSizeType sizeType = PublisherLogoSizeType.small,
    Key? key,
  }) =>
      PublisherLogo._(
        publisher: publisher,
        image: kIsTest ? informed.Image(publicId: AppRasterGraphics.testPublisherLogoLight) : publisher.lightLogo,
        sizeType: sizeType,
        key: key,
      );

  final Publisher publisher;
  final informed.Image? image;
  final PublisherLogoSizeType sizeType;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final publisherLogoId = image?.publicId;

    return publisherLogoId == null
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.iconRadius),
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimens.xs),
              child: Align(
                alignment: Alignment.centerLeft,
                child: kIsTest
                    ? Image.asset(
                        publisherLogoId,
                        width: sizeType.size,
                        height: sizeType.size,
                        fit: BoxFit.contain,
                      )
                    : CachedNetworkImage(
                        imageUrl: cloudinaryProvider
                            .withPublicId(publisherLogoId)
                            .transform()
                            .width(DimensionUtil.getPhysicalPixelsAsInt(sizeType.size, context))
                            .fit()
                            .generateNotNull(publisherLogoId, imageType: ImageType.png),
                        width: sizeType.size,
                        height: sizeType.size,
                        fit: BoxFit.contain,
                        cacheManager: PublisherLogoCacheManager(),
                      ),
              ),
            ),
          );
  }
}

extension PublisherLogoSizeTypeExt on PublisherLogoSizeType {
  double get size {
    switch (this) {
      case PublisherLogoSizeType.small:
        return AppDimens.smallPublisherLogoSize;
      case PublisherLogoSizeType.medium:
        return AppDimens.mediumPublisherLogoSize;
    }
  }
}

class PublisherLogoCacheManager extends CacheManager with ImageCacheManager {
  factory PublisherLogoCacheManager() {
    return _instance;
  }

  PublisherLogoCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 30),
            maxNrOfCacheObjects: 200,
          ),
        );

  static const key = 'publisherLogoCachedImageData';

  static final PublisherLogoCacheManager _instance = PublisherLogoCacheManager._();
}
