import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';

class SelectedArticlesLabel extends StatelessWidget {
  const SelectedArticlesLabel({
    required this.topic,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      onTap: onTap,
      tapPadding: const EdgeInsets.symmetric(vertical: AppDimens.ml),
      child: Text(
        LocaleKeys.dailyBrief_articles.tr(
          args: [topic.entries.length.toString()],
        ),
        textAlign: TextAlign.start,
        style: AppTypography.b2Regular.copyWith(color: AppColors.white),
      ),
    );
  }
}
