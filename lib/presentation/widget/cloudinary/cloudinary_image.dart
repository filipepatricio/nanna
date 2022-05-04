import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_config.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

export 'cloudinary_config.dart';

const _fadeDuration = Duration(milliseconds: 200);

class CloudinaryImage extends HookWidget {
  final String publicId;
  final double width;
  final double height;
  final BoxFit fit;
  final Alignment alignment;
  final String testImage;
  final CloudinaryConfig config;
  final bool showLoadingShimmer;
  final bool showDarkened;

  const CloudinaryImage({
    required this.publicId,
    required this.width,
    required this.height,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.testImage = AppRasterGraphics.testReadingListCoverImage,
    this.config = const CloudinaryConfig(),
    this.showLoadingShimmer = true,
    this.showDarkened = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkeningDecoration = BoxDecoration(
      color: showDarkened ? AppColors.black40 : null,
    );

    if (kIsTest) {
      return Container(
        foregroundDecoration: darkeningDecoration,
        child: Image.asset(
          testImage,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    final imageProvider = useCloudinaryProvider();
    final imageUrl = config.apply(context, publicId, imageProvider).autoQuality().generateNotNull();

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, image) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image,
            fit: fit,
            alignment: alignment,
          ),
        ),
        foregroundDecoration: darkeningDecoration,
      ),
      progressIndicatorBuilder: (context, _, __) => showLoadingShimmer
          ? const LoadingShimmer(
              mainColor: AppColors.pastelGreen,
              baseColor: AppColors.darkLinen,
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.pastelGreen,
                strokeWidth: 3.0,
              ),
            ),
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      fadeInDuration: _fadeDuration,
    );
  }
}
