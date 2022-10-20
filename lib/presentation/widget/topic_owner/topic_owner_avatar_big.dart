part of 'topic_owner_avatar.dart';

class _TopicOwnerAvatarBig extends StatelessWidget {
  const _TopicOwnerAvatarBig({
    required this.owner,
    required this.mode,
    Key? key,
  }) : super(key: key);

  final TopicOwner owner;
  final Brightness mode;

  @override
  Widget build(BuildContext context) {
    if (owner is UnknownOwner) {
      return const TopicOwnerAvatarUnknown();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TopicOwnerImage(
          owner: owner,
          imageWidth: AppDimens.avatarSizeBig,
          imageHeight: AppDimens.avatarSizeBig,
          editorAvatar: AppVectorGraphics.editorialTeamAvatarBig,
        ),
        const SizedBox(width: AppDimens.m + AppDimens.xxs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                owner.name,
                style: AppTypography.h2Medium.copyWith(
                  color: mode == Brightness.light ? AppColors.white : null,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
              ),
              Text(
                owner is Expert
                    ? LocaleKeys.topic_owner_expertIn.tr(args: [(owner as Expert).areaOfExpertise])
                    : LocaleKeys.topic_owner_editorialTeam.tr(),
                style: AppTypography.b3Regular.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
