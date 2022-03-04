import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

const _lowestQuality = '1';
const _fadeDuration = Duration(milliseconds: 100);

class CloudinaryProgressiveImage extends StatelessWidget {
  final double width;
  final double height;
  final CloudinaryTransformation cloudinaryTransformation;
  final BoxFit fit;
  final Alignment alignment;
  final String testImage;

  const CloudinaryProgressiveImage({
    required this.width,
    required this.height,
    required this.cloudinaryTransformation,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.testImage = AppRasterGraphics.testReadingListCoverImage,
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

    return ProgressiveImage.custom(
      alignment: alignment,
      placeholderBuilder: (context) => LoadingShimmer(
        width: width,
        height: height,
        mainColor: AppColors.white,
      ),
      thumbnail: CachedNetworkImageProvider(
        cloudinaryTransformation.quality(_lowestQuality).generateNotNull(),
      ),
      image: CachedNetworkImageProvider(
        cloudinaryTransformation.autoQuality().generateNotNull(),
      ),
      width: width,
      height: height,
      fit: fit,
      fadeDuration: _fadeDuration,
    );
  }
}
