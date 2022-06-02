import 'package:better_informed_mobile/domain/article/data/article_kind.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoverLabel extends StatelessWidget {
  const CoverLabel._({
    this.icon,
    this.label,
    this.color,
    this.child,
    Key? key,
  })  : assert(
          child == null || (icon == null && label == null),
          'The label can contain either a child or icon and label, not both',
        ),
        super(key: key);

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

  factory CoverLabel.articleKind(ArticleKind kind) => CoverLabel._(
        label: kind.name,
        color: AppColors.darkLinen,
      );

  factory CoverLabel.audio() => CoverLabel._(
        child: AudioIcon.dark(height: AppDimens.backArrowSize),
      );

  final String? icon;
  final String? label;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.xs,
        horizontal: child != null ? AppDimens.xs : AppDimens.s,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.xs),
        color: color ?? AppColors.background,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null)
            child!
          else ...[
            if (icon != null)
              SvgPicture.asset(
                icon!,
                width: 14,
                height: 14,
                fit: BoxFit.contain,
              ),
            if (label != null) ...[
              const SizedBox(width: AppDimens.xs),
              Text(
                label!,
                maxLines: 1,
                style: AppTypography.subH2Bold,
              ),
            ],
          ]
        ],
      ),
    );
  }
}