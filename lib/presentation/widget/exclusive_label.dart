import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _padding = 6.0;

class ExclusiveLabel extends StatelessWidget {
  const ExclusiveLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.xxs),
        color: AppColors.limeGreen,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Exclusive'.toUpperCase(),
            style: AppTypography.labelText,
          ),
          const SizedBox(width: AppDimens.s),
          SvgPicture.asset(AppVectorGraphics.lock),
        ],
      ),
    );
  }
}
