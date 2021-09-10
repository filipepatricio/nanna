import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ArticleLabel extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const ArticleLabel._({
    required this.label,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  factory ArticleLabel.opinion({Color? backgroundColor, Key? key}) => ArticleLabel._(
        label: LocaleKeys.article_label_opinion.tr(),
        backgroundColor: backgroundColor ?? AppColors.background,
        key: key,
      );

  factory ArticleLabel.feature({Color? backgroundColor, Key? key}) => ArticleLabel._(
        label: LocaleKeys.article_label_feature.tr(),
        backgroundColor: backgroundColor ?? AppColors.background,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.s),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelText,
      ),
    );
  }
}
