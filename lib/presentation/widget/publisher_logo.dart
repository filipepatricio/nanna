import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart' as informed;
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _publisherLogoSize = 20.0;

class PublisherLogo extends HookWidget {
  const PublisherLogo._({
    required this.publisher,
    required this.image,
    required this.dimension,
    Key? key,
  }) : super(key: key);

  factory PublisherLogo.dark({required Publisher publisher, double dimension = _publisherLogoSize, Key? key}) =>
      PublisherLogo._(
        publisher: publisher,
        image: kIsTest ? informed.Image(publicId: AppRasterGraphics.testPublisherLogoDark) : publisher.darkLogo,
        dimension: dimension,
        key: key,
      );

  factory PublisherLogo.light({required Publisher publisher, double dimension = _publisherLogoSize, Key? key}) =>
      PublisherLogo._(
        publisher: publisher,
        image: kIsTest ? informed.Image(publicId: AppRasterGraphics.testPublisherLogoLight) : publisher.lightLogo,
        dimension: dimension,
        key: key,
      );

  final Publisher publisher;
  final informed.Image? image;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final publisherLogoId = image?.publicId;

    return publisherLogoId == null
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.iconRadius),
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimens.s),
              child: Align(
                alignment: Alignment.centerLeft,
                child: kIsTest
                    ? Image.asset(
                        publisherLogoId,
                        width: _publisherLogoSize,
                        height: _publisherLogoSize,
                        fit: BoxFit.contain,
                      )
                    : CachedNetworkImage(
                        imageUrl: cloudinaryProvider
                            .withPublicId(publisherLogoId)
                            .transform()
                            .width(DimensionUtil.getPhysicalPixelsAsInt(_publisherLogoSize, context))
                            .fit()
                            .generateNotNull(publisherLogoId, imageType: ImageType.png),
                        width: dimension,
                        height: dimension,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          );
  }
}
