import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_config.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:progressive_image/progressive_image.dart';

export 'cloudinary_config.dart';

const _lowestQuality = '1';
const _fadeDuration = Duration(milliseconds: 100);

class CloudinaryProgressiveImage extends HookWidget {
  final String publicId;
  final double width;
  final double height;
  final BoxFit fit;
  final Alignment alignment;
  final String testImage;
  final CloudinaryConfig config;
  final bool showLoadingShimmer;

  const CloudinaryProgressiveImage({
    required this.publicId,
    required this.width,
    required this.height,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.testImage = AppRasterGraphics.testReadingListCoverImage,
    this.config = const CloudinaryConfig(),
    this.showLoadingShimmer = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsTest) {
      return Image.asset(
        testImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    final imageProvider = useCloudinaryProvider();
    final imageUrl = config.apply(context, publicId, imageProvider).autoQuality().generateNotNull();

    final thumbnailProvider = useCloudinaryProvider();
    final thumbnailUrl = config.apply(context, publicId, thumbnailProvider).quality(_lowestQuality).generateNotNull();

    return ProgressiveImage.custom(
      alignment: alignment,
      placeholderBuilder: (context) {
        return showLoadingShimmer
            ? LoadingShimmer(
                width: width,
                height: height,
                mainColor: AppColors.white,
              )
            : const CircularProgressIndicator(color: AppColors.limeGreen);
      },
      thumbnail: CachedNetworkImageProvider(thumbnailUrl),
      image: CachedNetworkImageProvider(imageUrl),
      width: width,
      height: height,
      fit: fit,
      fadeDuration: _fadeDuration,
    );
  }
}
