import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curator_avatar_unknown.dart';
import 'package:better_informed_mobile/presentation/widget/curator_image.dart';
import 'package:flutter/material.dart';

class CuratorAvatarBig extends StatelessWidget {
  const CuratorAvatarBig({
    required this.curator,
    Key? key,
  }) : super(key: key);

  final Curator curator;

  @override
  Widget build(BuildContext context) {
    if (curator is UnknownCurator) {
      return const CuratorAvatarUnknown();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CuratorImage(
          curator: curator,
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
                curator.name,
                style: AppTypography.h2Medium,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
              ),
              Text(
                curator.maybeMap(
                  expert: (expert) => context.l10n.topic_owner_expertIn(expert.areaOfExpertise),
                  orElse: () => context.l10n.topic_owner_editorialTeam,
                ),
                style: AppTypography.b3Regular.copyWith(
                  color: AppColors.of(context).textSecondary,
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
