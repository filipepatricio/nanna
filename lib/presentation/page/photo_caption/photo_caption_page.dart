import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart' as informed;
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhotoCaptionPage extends HookWidget {
  const PhotoCaptionPage({
    required this.cloudinaryImage,
    Key? key,
  }) : super(key: key);

  final informed.Image cloudinaryImage;

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height;
    final imageCaption = cloudinaryImage.caption;
    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: AppColors.white,
          highlightColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          onPressed: () {
            AutoRouter.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.xxxc),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: AppDimens.photoCaptionImageContainerWidth(context),
              height: AppDimens.photoCaptionImageContainerHeight(context),
              color: AppColors.textPrimary,
              child: CloudinaryImage(
                publicId: cloudinaryImage.publicId,
                config: CloudinaryConfig(
                  platformBasedExtension: true,
                  autoGravity: true,
                  width: imageWidth,
                ),
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.fitWidth,
                showLoadingShimmer: false,
                testImage: AppRasterGraphics.testArticleHeroImage,
              ),
            ),
            if (imageCaption != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: InformedMarkdownBody(
                  markdown: imageCaption,
                  baseTextStyle: AppTypography.metadata1Regular.copyWith(
                    height: 1.4,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
