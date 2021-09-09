import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:flutter/material.dart';

class DailyBriefTitleHero extends StatelessWidget {
  final String title;

  const DailyBriefTitleHero({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: HeroTag.dailyBriefTitle,
      child: Text(
        title,
        style: AppTypography.h1Bold.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
