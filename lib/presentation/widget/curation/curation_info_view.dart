import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curator_avatar_unknown.dart';
import 'package:better_informed_mobile/presentation/widget/curator_image.dart';
import 'package:flutter/material.dart';

class CurationInfoView extends StatelessWidget {
  const CurationInfoView({
    required this.curationInfo,
    this.shortLabel = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final CurationInfo curationInfo;

  final bool shortLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (curationInfo.curator is UnknownCurator) {
      return const CuratorAvatarUnknown();
    }

    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(AppDimens.m),
      onTap: onTap ?? () => context.pushRoute(TopicOwnerPageRoute(owner: curationInfo.curator)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CuratorImage(
            curator: curationInfo.curator,
            imageWidth: AppDimens.avatarSize,
            imageHeight: AppDimens.avatarSize,
            editorAvatar: AppVectorGraphics.editorialTeamAvatar,
          ),
          const SizedBox(width: AppDimens.s),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.b3Regular.copyWith(
                  height: 1,
                  letterSpacing: 0,
                  color: AppColors.darkerGrey,
                ),
                children: [
                  if (!shortLabel) TextSpan(text: '${curationInfo.byline} '),
                  TextSpan(
                    text: curationInfo.curator.name,
                    style: AppTypography.b3Regular.copyWith(
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.textPrimary,
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
