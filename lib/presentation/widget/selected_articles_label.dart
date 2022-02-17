import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';

class SelectedArticlesLabel extends StatelessWidget {
  const SelectedArticlesLabel({
    required this.onArticlesLabelTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final void Function() onArticlesLabelTap;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      onTap: onArticlesLabelTap,
      tapPadding: const EdgeInsets.symmetric(vertical: AppDimens.ml),
      child: Text(
        LocaleKeys.todaysTopics_selectedArticles.tr(
          args: [topic.readingList.entries.length.toString()],
        ),
        textAlign: TextAlign.start,
        style: AppTypography.b1Regular.copyWith(
          decoration: TextDecoration.underline,
          height: 1,
          color: AppColors.white,
        ),
      ),
    );
  }
}
