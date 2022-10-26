part of 'topic_owner_avatar.dart';

class _TopicOwnerAvatarSmall extends StatelessWidget {
  const _TopicOwnerAvatarSmall({
    required this.owner,
    required this.mode,
    this.shortLabel = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Curator owner;
  final Brightness mode;
  final bool shortLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (owner is UnknownCurator) {
      return const TopicOwnerAvatarUnknown();
    }

    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(AppDimens.m),
      onTap: onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CuratorImage(
            curator: owner,
            imageWidth: AppDimens.avatarSize,
            imageHeight: AppDimens.avatarSize,
            editorAvatar: AppVectorGraphics.editorialTeamAvatar,
          ),
          const SizedBox(width: AppDimens.s),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  if (!shortLabel)
                    TextSpan(
                      text: tr(owner is EditorialTeam ? LocaleKeys.topic_recommendedBy : LocaleKeys.topic_curatedBy),
                      style: AppTypography.subH1Medium.copyWith(
                        height: 1,
                        color: mode == Brightness.dark ? null : AppColors.white,
                      ),
                    ),
                  TextSpan(
                    text: owner.name,
                    style: AppTypography.subH1Bold.copyWith(
                      height: 1,
                      color: mode == Brightness.dark ? null : AppColors.white,
                    ),
                  ),
                ],
              ),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
