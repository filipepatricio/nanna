import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoverLabel extends StatelessWidget {
  const CoverLabel._({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  factory CoverLabel.topic({required TopicPreview topic}) => topic.owner is Expert
      ? CoverLabel._(
          icon: AppVectorGraphics.expertTopicLabel,
          label: '${LocaleKeys.topic_expert.tr()} ${LocaleKeys.topic_label.tr()}',
        )
      : CoverLabel._(
          icon: AppVectorGraphics.topicLabel,
          label: LocaleKeys.topic_label.tr(),
        );

  factory CoverLabel.article() => CoverLabel._(
        icon: AppVectorGraphics.articleLabel,
        label: LocaleKeys.article_label.tr(),
      );

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.xs,
        horizontal: AppDimens.s,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.xs),
        color: AppColors.background,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 14,
            width: 14,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: AppDimens.xs),
          Text(
            label,
            maxLines: 1,
            style: AppTypography.subH2Bold,
          ),
        ],
      ),
    );
  }
}
