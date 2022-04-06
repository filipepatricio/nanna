import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _imageWidth = 80.0;
const _imageHeight = 80.0;

class AudioPlayerBanner extends HookWidget {
  const AudioPlayerBanner({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: AppColors.grey,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            const LinearProgressIndicator(
              value: 0.4, //TODO: listen audio progress position/totalDuration
              color: AppColors.textPrimary,
              backgroundColor: AppColors.transparent,
              minHeight: 4,
            ),
            Row(
              children: [
                if (imageId != null)
                  CloudinaryProgressiveImage(
                    cloudinaryTransformation: cloudinaryProvider
                        .withPublicIdAsPlatform(imageId)
                        .transform()
                        .autoGravity()
                        .withLogicalSize(_imageWidth, _imageHeight, context),
                    width: _imageWidth,
                    height: _imageHeight,
                    testImage: AppRasterGraphics.testArticleHeroImage,
                  ),
                const SizedBox(width: AppDimens.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tr(LocaleKeys.continueListening),
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.textGrey),
                      ),
                      Text(
                        article.title,
                        style: AppTypography.b2Bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.l),
                SizedBox(
                  width: AppDimens.xxl + AppDimens.xxs,
                  height: AppDimens.xxl + AppDimens.xxs,
                  child: FittedBox(
                    child: AudioFloatingControlButton(
                      article: article,
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.ml),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
