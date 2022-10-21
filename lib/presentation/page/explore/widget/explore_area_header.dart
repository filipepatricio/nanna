import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExploreAreaHeader extends StatelessWidget {
  const ExploreAreaHeader({
    required this.title,
    required this.isPreferred,
    this.description,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool isPreferred;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final optDescription = description;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.h2Medium,
              ),
              if (isPreferred) SvgPicture.asset(AppVectorGraphics.starFilled),
            ],
          ),
          if (optDescription != null) ...[
            const SizedBox(height: AppDimens.xs),
            Text(
              optDescription,
              style: AppTypography.subH1Medium.copyWith(
                color: AppColors.textGrey,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
