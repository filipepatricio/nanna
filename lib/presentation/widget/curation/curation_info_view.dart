import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curator_avatar_unknown.dart';
import 'package:better_informed_mobile/presentation/widget/curator_image.dart';
import 'package:flutter/material.dart';

class CurationInfoView extends StatelessWidget {
  const CurationInfoView({
    required this.curationInfo,
    this.shortLabel = false,
    this.onTap,
    this.style,
    this.imageDimension = AppDimens.avatarSize,
    Key? key,
  }) : super(key: key);

  final CurationInfo curationInfo;

  final bool shortLabel;
  final VoidCallback? onTap;
  final TextStyle? style;
  final double imageDimension;

  @override
  Widget build(BuildContext context) {
    if (curationInfo.curator is UnknownCurator) {
      return const CuratorAvatarUnknown();
    }

    return PaddingTapWidget(
      alignment: AlignmentDirectional.centerStart,
      tapPadding: const EdgeInsets.all(AppDimens.m),
      onTap: onTap ?? () => context.pushRoute(TopicOwnerPageRoute(owner: curationInfo.curator)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CuratorImage(
            curator: curationInfo.curator,
            imageWidth: imageDimension,
            imageHeight: imageDimension,
            editorAvatar: AppVectorGraphics.editorialTeamAvatar,
          ),
          const SizedBox(width: AppDimens.s),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: style ??
                    AppTypography.sansTextSmallLausanne.copyWith(
                      color: AppColors.of(context).textTertiary,
                      height: 1,
                    ),
                children: [
                  if (!shortLabel) TextSpan(text: '${curationInfo.byline} '),
                  TextSpan(
                    text: curationInfo.curator.name,
                    style: style ??
                        AppTypography.sansTextSmallLausanne.copyWith(
                          color: AppColors.of(context).textTertiary,
                          height: 1,
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
