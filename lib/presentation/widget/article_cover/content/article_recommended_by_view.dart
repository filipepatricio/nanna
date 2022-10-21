import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArticleRecommendedByView extends StatelessWidget {
  const ArticleRecommendedByView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AppVectorGraphics.editorialTeamAvatar),
        const SizedBox(width: AppDimens.s),
        Text(
          LocaleKeys.dailyBrief_recommendedBy_informed.tr(),
          style: AppTypography.b3Regular.copyWith(
            height: 1,
            letterSpacing: 0,
            color: AppColors.darkerGrey,
          ),
        ),
      ],
    );
  }
}
