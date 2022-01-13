import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicOwnerAvatar extends HookWidget {
  const TopicOwnerAvatar({
    required this.owner,
    Key? key,
    this.profileMode = false,
    this.lightMode = false,
    this.imageHeight = AppDimens.avatarSize,
    this.imageWidth = AppDimens.avatarSize,
    this.fontSize,
    this.onTap,
  }) : super(key: key);

  final TopicOwner owner;
  final bool profileMode;
  final bool lightMode;
  final double imageHeight;
  final double imageWidth;
  final double? fontSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = owner.avatar?.publicId;

    // Using non-dynamic resolution to force the use of the same cached image everywhere
    // Using 4 because the max. device pixel ratio currently is 3, 3.5. 4 covers all devices with good quality
    final avatarResolutionWidth = (imageWidth * 4).toInt();
    final avatarResolutionHeight = (imageHeight * 4).toInt();

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: imageWidth,
            height: imageHeight,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: imageId != null
                ? CloudinaryProgressiveImage(
                    testImage: AppRasterGraphics.editorialTeamAvatar,
                    cloudinaryTransformation: cloudinaryProvider
                        .withPublicIdAsPlatform(imageId)
                        .transform()
                        .width(avatarResolutionWidth)
                        .height(avatarResolutionHeight)
                        .autoQuality()
                        .autoGravity(),
                    height: imageHeight,
                    width: imageWidth,
                  )
                : Image.asset(
                    owner is Editor ? AppRasterGraphics.editorialTeamAvatar : AppRasterGraphics.expertAvatar,
                    width: imageWidth,
                    height: imageHeight,
                  ),
          ),
          const SizedBox(width: AppDimens.s),
          Expanded(
            child: Text(
              profileMode ? owner.name : LocaleKeys.article_articleBy.tr(args: [owner.name]),
              softWrap: true,
              maxLines: 2,
              style: profileMode
                  ? AppTypography.h3bold.copyWith(
                      fontSize: fontSize,
                      color: lightMode ? AppColors.white : AppColors.textPrimary,
                    )
                  : AppTypography.h3boldLoraItalic.copyWith(
                      fontSize: fontSize,
                      color: lightMode ? AppColors.white : AppColors.textPrimary,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
