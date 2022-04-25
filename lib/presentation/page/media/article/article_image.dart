import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart' as d;
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleImage extends HookWidget {
  const ArticleImage({
    required this.image,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.cardColor,
    Key? key,
  }) : super(key: key);

  final d.ArticleImage image;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    if (image is d.ArticleImageCloudinary) {
      return CloudinaryProgressiveImage(
        publicId: (image as d.ArticleImageCloudinary).cloudinaryImage.publicId,
        config: CloudinaryConfig(
          platformBasedExtension: true,
          autoGravity: true,
          width: width,
          height: height,
        ),
        width: width,
        height: height,
        fit: fit,
        testImage: AppRasterGraphics.testArticleHeroImage,
      );
    }

    if (image is d.ArticleImageRemote) {
      return CachedNetworkImage(
        imageUrl: (image as d.ArticleImageRemote).url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) => LoadingShimmer(
          width: width,
          height: height,
          mainColor: AppColors.white,
        ),
      );
    }

    return Container(
      color: cardColor,
      width: width,
      height: height,
    );
  }
}
