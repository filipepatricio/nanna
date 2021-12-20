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
    this.imageHeight = 42.0,
    this.imageWidth = 42.0,
    this.fontSize,
  }) : super(key: key);

  final TopicOwner owner;
  final bool profileMode;
  final bool lightMode;
  final double imageHeight;
  final double imageWidth;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = owner.avatar?.publicId;

    return Row(
      children: [
        if (imageId != null)
          CloudinaryProgressiveImage(
            cloudinaryTransformation: cloudinaryProvider
                .withPublicIdAsPlatform(imageId)
                .transform()
                .withLogicalSize(imageWidth, imageHeight, context)
                .autoGravity(),
            height: imageHeight,
            width: imageWidth,
          )
        else
          Image.asset(
            owner is Editor ? AppRasterGraphics.editorialTeamAvatar : AppRasterGraphics.expertAvatar,
            width: imageWidth,
            height: imageHeight,
          ),
        const SizedBox(width: AppDimens.s),
        Text(
          profileMode ? owner.name : LocaleKeys.article_articleBy.tr(args: [owner.name]),
          style: AppTypography.metadata2BoldLoraItalic.copyWith(
            fontSize: fontSize,
            color: lightMode ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
