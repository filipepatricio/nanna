import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart' as informed;
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _publisherLogoSize = 24.0;

class PublisherLogo extends HookWidget {
  final Publisher publisher;
  final informed.Image? image;

  const PublisherLogo._({required this.publisher, required this.image, Key? key}) : super(key: key);

  factory PublisherLogo.dark({required Publisher publisher, Key? key}) => PublisherLogo._(
        publisher: publisher,
        image: kIsTest ? informed.Image(publicId: AppRasterGraphics.testPublisherLogoDark) : publisher.darkLogo,
        key: key,
      );

  factory PublisherLogo.light({required Publisher publisher, Key? key}) => PublisherLogo._(
        publisher: publisher,
        image: kIsTest ? informed.Image(publicId: AppRasterGraphics.testPublisherLogoLight) : publisher.lightLogo,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final publisherLogoId = image?.publicId;

    return publisherLogoId == null
        ? const SizedBox()
        : Padding(
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
                  : Image.network(
                      cloudinaryProvider
                          .withPublicIdAsPng(publisherLogoId)
                          .transform()
                          .width(DimensionUtil.getPhysicalPixelsAsInt(_publisherLogoSize, context))
                          .fit()
                          .generateNotNull(),
                      width: _publisherLogoSize,
                      height: _publisherLogoSize,
                      fit: BoxFit.contain,
                    ),
            ),
          );
  }
}
