part of 'topic_owner_avatar.dart';

class _TopicOwnerImage extends HookWidget {
  const _TopicOwnerImage({
    required this.owner,
    required this.imageWidth,
    required this.imageHeight,
    this.editorAvatar = AppVectorGraphics.editorialTeamAvatarBig,
    Key? key,
  }) : super(key: key);

  final TopicOwner owner;
  final double imageWidth;
  final double imageHeight;
  final String editorAvatar;

  @override
  Widget build(BuildContext context) {
    final imageId = owner.avatar?.publicId;
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
              placeholder: (context, _) => LoadingShimmer(
                width: imageWidth,
                height: imageHeight,
                mainColor: AppColors.white,
              ),
            )
          : SvgPicture.asset(
              owner is Expert ? AppVectorGraphics.expertAvatar : editorAvatar,
              width: imageWidth,
              height: imageHeight,
            ),
    );
  }
}
