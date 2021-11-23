import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _imageHeight = 42.0;
const _imageWidth = 42.0;

class TopicOwnerAvatar extends HookWidget {
  const TopicOwnerAvatar({required this.owner, Key? key, this.profileMode = false}) : super(key: key);

  final TopicOwner owner;
  final bool profileMode;

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
                .withLogicalSize(_imageWidth, _imageHeight, context)
                .autoGravity(),
            height: _imageHeight,
            width: _imageWidth,
          )
        else
          Image.asset(
            owner is Editor ? AppRasterGraphics.editorialTeamAvatar : AppRasterGraphics.expertAvatar,
            width: _imageWidth,
            height: _imageHeight,
          ),
        const SizedBox(width: AppDimens.s),
        Text(
          profileMode ? owner.name : 'By ${owner.name}',
          style: AppTypography.metadata2BoldLoraItalic,
        ),
      ],
    );
  }
}
