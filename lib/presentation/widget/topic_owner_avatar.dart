import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicOwnerAvatar extends HookWidget {
  const TopicOwnerAvatar({
    required this.owner,
    Key? key,
    this.withPrefix = false,
    this.textStyle = defaultAvatarTextStyle,
    this.mode = Brightness.dark,
    this.imageSize = AppDimens.avatarSize,
    this.underlined = false,
    this.fontSize,
    this.onTap,
  }) : super(key: key);

  final TopicOwner owner;
  final TextStyle textStyle;
  final Brightness mode;
  final bool underlined;
  final bool withPrefix;
  final double imageSize;
  final double? fontSize;
  final Function()? onTap;

  static const defaultAvatarTextStyle = AppTypography.h3boldLoraItalic;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = owner.avatar?.publicId;
    final imageWidth = imageSize;
    final imageHeight = imageSize;

    // Using non-dynamic resolution to force the use of the same cached image everywhere
    // Using 4 because the max. device pixel ratio currently is 3, 3.5. 4 covers all devices with good quality
    final avatarResolutionWidth = (imageWidth * 4).toInt();
    final avatarResolutionHeight = (imageHeight * 4).toInt();

    if (owner is UnknownOwner) {
      return const UnknownOwnerAvatar();
    }

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
                    owner is Expert ? AppRasterGraphics.expertAvatar : AppRasterGraphics.editorialTeamAvatar,
                    width: imageWidth,
                    height: imageHeight,
                  ),
          ),
          const SizedBox(width: AppDimens.s),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  if (withPrefix)
                    TextSpan(
                      text: '${LocaleKeys.article_by.tr()} ',
                      style: textStyle.copyWith(
                        fontSize: fontSize,
                        color: mode == Brightness.light ? AppColors.white : null,
                      ),
                    ),
                  TextSpan(
                    text: owner.name,
                    style: textStyle.copyWith(
                      fontSize: fontSize,
                      color: mode == Brightness.light ? AppColors.white : null,
                      decoration: underlined ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class UnknownOwnerAvatar extends StatelessWidget {
  const UnknownOwnerAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: AppDimens.zero,
    );
  }
}
