import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CuratorImage extends HookWidget {
  const CuratorImage({
    required this.curator,
    required this.imageWidth,
    required this.imageHeight,
    this.editorAvatar = AppVectorGraphics.editorialTeamAvatarBig,
    Key? key,
  }) : super(key: key);

  final Curator curator;
  final double imageWidth;
  final double imageHeight;
  final String editorAvatar;

  @override
  Widget build(BuildContext context) {
    final imageId = curator.avatar?.publicId;
    final cloudinaryProvider = useCloudinaryProvider();
    // Using non-dynamic resolution to force the use of the same cached image everywhere
    // Using 4 because the max. device pixel ratio currently is 3, 3.5. 4 covers all devices with good quality
    final avatarResolutionWidth = (imageWidth * 4).toInt();
    final avatarResolutionHeight = (imageHeight * 4).toInt();

    return Container(
      width: imageWidth,
      height: imageHeight,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: imageId != null && !kIsTest
          ? CachedNetworkImage(
              width: imageWidth,
              height: imageHeight,
              imageUrl: cloudinaryProvider
                  .withPublicId(imageId)
                  .transform()
                  .width(avatarResolutionWidth)
                  .height(avatarResolutionHeight)
                  .autoQuality()
                  .autoGravity()
                  .generateAsPlatform(imageId),
              placeholder: (context, _) => LoadingShimmer.defaultColor(
                width: imageWidth,
                height: imageHeight,
              ),
            )
          : SvgPicture.asset(
              curator is ExpertCurator ? AppVectorGraphics.expertAvatar : editorAvatar,
              width: imageWidth,
              height: imageHeight,
            ),
    );
  }
}
