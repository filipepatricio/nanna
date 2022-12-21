import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart' as d;
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleImage extends HookWidget {
  const ArticleImage({
    required this.image,
    this.fit = BoxFit.cover,
    this.cardColor,
    this.darkeningMode = DarkeningMode.none,
    Key? key,
  }) : super(key: key);

  final d.ArticleImage image;
  final BoxFit fit;
  final Color? cardColor;
  final DarkeningMode darkeningMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        if (image is d.ArticleImageCloudinary) {
          return CloudinaryImage(
            publicId: (image as d.ArticleImageCloudinary).cloudinaryImage.publicId,
            config: CloudinaryConfig(
              width: width,
              height: height,
            ),
            width: width,
            height: height,
            fit: fit,
            darkeningMode: darkeningMode,
            testImage: AppRasterGraphics.testArticleHeroImage,
          );
        }

        if (image is d.ArticleImageRemote) {
          return CachedNetworkImage(
            imageUrl: (image as d.ArticleImageRemote).url,
            width: width,
            height: height,
            fit: fit,
            imageBuilder: (context, image) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                color: darkeningMode == DarkeningMode.solid ? AppColors.overlay : null,
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: cardColor ?? AppColors.overlay,
              width: width,
              height: height,
            ),
            placeholder: (context, _) => LoadingShimmer.defaultColor(
              width: width,
              height: height,
            ),
          );
        }

        return Container(
          color: cardColor,
          width: width,
          height: height,
        );
      },
    );
  }
}
